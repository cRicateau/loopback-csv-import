_         = require 'lodash'
async     = require 'async'
csv       = require 'fast-csv'
fork      = require('child_process').fork
fs        = require 'fs'
path      = require 'path'
loopback  = require 'loopback'

module.exports = (Invoice) ->

  Invoice.remoteMethod 'upload',
    accepts: [
      arg: 'req'
      type: 'object'
      http:
        source: 'req'
    ]
    http:
      verb: 'post'
      path: '/upload'

  Invoice.upload = (req, callback) ->
    # Set up the container
    Container = Invoice.app.models.Container
    FileUpload = Invoice.app.models.FileUpload
    containerName = "invoice-#{Math.round(Date.now())}-#{Math.round(Math.random() * 1000)}"
    async.waterfall [
      (done) ->
        Container.createContainer name: containerName, done
      (container, done) ->
        req.params.container = containerName
        Container.upload req, {}, done
      (fileContainer, done) ->
        # Store the state of the upload in the database
        FileUpload.create
          date: new Date()
          fileType: Invoice.modelName
          status: 'PENDING'
        , (err, fileUpload) ->
          return done err, fileContainer, fileUpload
    ], (err, fileContainer, fileUpload) ->
      return callback err if err
      params =
        fileUpload: fileUpload.id
        root: Invoice.app.datasources.container.settings.root
        container: fileContainer.files.file[0].container
        file: fileContainer.files.file[0].name

      # Launch a fork process by calling a script
      fork __dirname + '/../../server/scripts/import-invoices.coffee', [
        JSON.stringify params
      ]
      callback null, fileContainer

  Invoice.import = (container, file, options, callback) ->
    # Initialize a context object that will hold the transaction
    ctx = {}

    # The import_preprocess is used to initialize the sql transaction
    Invoice.import_preprocess ctx, container, file, options, (err) ->
      Invoice.import_process ctx, container, file, options, (importError) ->
        if importError
          # rollback does not apply the transaction
          async.waterfall [
            (done) ->
              ctx.transaction.rollback done
            (done) ->
              # Do some other stuff to clean and acknowledge the end of the import
              Invoice.import_postprocess_error ctx, container, file, options, done
            (done) ->
              Invoice.import_clean ctx, container, file, options, done
          ], ->
            return callback importError

        else
          async.waterfall [
            (done) ->
              # The commit applies the changes to the database
              ctx.transaction.commit done
            (done) ->
               # Do some other stuff to clean and acknowledge the end of the import
              Invoice.import_postprocess_success ctx, container, file, options, done
            (done) ->
              Invoice.import_clean ctx, container, file, options, done
          ], ->
            return callback null

  Invoice.import_preprocess = (ctx, container, file, options, callback) ->
    Invoice.beginTransaction
      isolationLevel: Invoice.Transaction.READ_UNCOMMITTED
    , (err, transaction) ->
      ctx.transaction = transaction
      return callback err

  Invoice.import_process = (ctx, container, file, options, callback) ->
    fileContent = []
    filename = path.join Invoice.app.datasources.container.settings.root, container, file

    # Here we fix the delimiter of the csv file to semicolon.
    stream = csv
      delimiter: ';'
      headers: true
    stream.on 'data', (data) ->
      fileContent.push data
    stream.on 'end', ->
      errors = []
      # Iterate over every line of the file
      async.mapSeries [0..fileContent.length], (i, done) ->
        return done() if not fileContent[i]?
        # import_handleLine process the individual line
        Invoice.import_handleLine ctx, fileContent[i], options, (err) ->
          if err
            errors.push err
            # If an error is raised on a particular line, store it with the FileUploadError model
            # i + 2 is the real excel user-friendly index of the line
            Invoice.app.models.FileUploadError.create
              line: i + 2
              message: err.message
              fileUploadId: options.fileUpload
            , done null
          else
            done()
      , ->
        return callback errors if errors.length > 0
        return callback()
    fs.createReadStream(filename).pipe stream

  Invoice.import_postprocess_success = (ctx, container, file, options, callback) ->
    Invoice.app.models.FileUpload.findById options.fileUpload, (err, fileUpload) ->
      return callback err if err
      fileUpload.status = 'SUCCESS'
      fileUpload.save callback

  Invoice.import_postprocess_error = (ctx, container, file, options, callback) ->
    Invoice.app.models.FileUpload.findById options.fileUpload, (err, fileUpload) ->
      return callback err if err
      fileUpload.status = 'ERROR'
      fileUpload.save callback

  Invoice.import_clean = (ctx, container, file, options, callback) ->
    Invoice.app.models.Container.destroyContainer container, callback

  Invoice.import_handleLine = (ctx, line, uploadData, callback) ->
    LineHandler.validate line, (err) ->
      return callback err if err
      LineHandler.createInvoice ctx
      , line
      , callback

  LineHandler =
    createInvoice: (req, line, done) ->
      Invoice.findOne
        where:
          invoiceId: line.InvoiceId
      , req, (error, found) ->
        return done error if error

        invoice =
          invoiceId: line.InvoiceId
          amount: line.Amount
        invoice.id = invoice.id if found

        Invoice.upsert invoice, req, (error, invoice) ->
          if error
            done error, line.InvoiceId
          else
            done null, invoice

    rejectLine: (columnName, cellData, customErrorMessage,callback) ->
      err = new Error "Unprocessable entity in column #{columnName} where data = #{cellData} : #{customErrorMessage}"
      err.status = 422
      callback err

    # Do all the necessary checks to avoid SQL errors and check data integrity
    validate: (line, callback) ->
      if line.InvoiceId is ''
        return @rejectLine 'InvoiceId', line.InvoiceId, 'Missing InvoiceId', callback
      if _.isNaN parseInt line.InvoiceId
        return @rejectLine 'InvoiceId', line.InvoiceId, 'InvoiceId in not a number', callback
      if line.Amount is ''
        return @rejectLine 'Amount', line.Amount, 'Missing Amount', callback
      if _.isNaN parseInt line.Amount
        return @rejectLine 'Amount', line.Amount, 'Amount in not a number', callback
      callback()


