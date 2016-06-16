_ = require 'lodash'
debug = require('debug') 'loopback-csv-example:upload'
fork = require('child_process').fork
loopback = require 'loopback'
path = require 'path'
Promise = require 'bluebird'
async = require 'async'

module.exports = (Model, options) ->

  Model.upload = (req, callback) ->
    Container = Model.app.models.Container
    FileUpload = Model.app.models.FileUpload
    containerName = "#{Model.modelName}-#{Math.round(Date.now())}-#{Math.round(Math.random() * 1000)}"
    answer = null
    async.waterfall [
      (done) ->
        Container.createContainer name: containerName, done
      (container, done) ->
        req.params.container = containerName
        Container.upload req, {}, done
    ], (err, uploadAnswer) ->
      return callback err if err
      answer = uploadAnswer
      Model.create_file_upload()
      .then (fileUpload)->
        Model.fork_file_upload answer, fileUpload
      .then (answer) ->
        callback null, answer
      .catch (err) ->
        callback err

  Model.create_file_upload = ->
    Model.app.models.FileUpload.create
      date: new Date()
      fileType: Model.modelName
      status: 'PENDING'

  Model.fork_file_upload = (answer, fileUpload) ->
    new Promise (resolve, reject) ->
      if Model.upload_extractParams
        params = Model.upload_extractParams answer
      else
        params = {}
      params = _.merge params,
        model: Model.modelName
        fileUpload: fileUpload.id
        root: Model.app.datasources.container.settings.root
        container: answer.files.file[0].container
        file: answer.files.file[0].name
      Model.upload_fork params
      resolve answer

  Model.upload_fork = (params) ->
    fork "#{__dirname}/../../server/scripts/import-script.coffee", [
      JSON.stringify params
    ]

  if not Model.import_postprocess_hook
    Model.import_postprocess_hook = (ctx, container, file, options) ->
      new Promise (resolve, reject) -> resolve()

  Model.import = (container, file, options, callback) ->
    debug 'import', file, options
    ctx = {}
    Model.import_preprocess ctx, container, file, options
    .then ->
      Model.import_process ctx, container, file, options
    .then ->
      Model.import_postprocess_hook ctx, container, file, options
    .then ->
      ctx.transaction.commit (err) ->
        Model.exit_safely_after_success ctx, container, file, options, callback
    .catch (err) ->
      ctx.transaction.rollback (rollbackError) ->
        console.error(rollbackError) if rollbackError
        Model.exit_safely_after_error ctx, container, file, options, callback

  Model.exit_safely_after_success = (ctx, container, file, options, callback) ->
    Model.import_postprocess 'SUCCESS', ctx, container, file, options
    .then ->
      Model.import_clean ctx, container, file, options
    .then ->
      callback()
    .catch (err) ->
      callback err

  Model.exit_safely_after_error = (ctx, container, file, options, callback) ->
    Model.import_postprocess 'ERROR', ctx, container, file, options
    .then ->
      Model.import_clean ctx, container, file, options
    .then ->
      callback()
    .catch (err) ->
      callback err

  Model.import_preprocess = (ctx, container, file, options) ->
    debug 'import_preprocess', file, options
    return new Promise (resolve, reject) ->
      Model.beginTransaction
        isolationLevel: Model.Transaction.READ_UNCOMMITTED
      , (err, transaction) ->
        ctx.transaction = transaction
        return reject err if err
        return resolve()

  Model.import_postprocess = (status, ctx, container, file, options) ->
    return new Promise (resolve, reject) ->
      debug 'import_postprocess', status, file, options
      Model.app.models.FileUpload.findById options.fileUpload
      .then (fileUpload) ->
        fileUpload.status = status
        fileUpload.save (err, data) ->
          resolve(data)
      .catch (err) ->
        reject err

  Model.import_clean = (ctx, container, file, options) ->
    debug 'import_clean', file, options
    return new Promise (resolve, reject) ->
      Model.app.models.Container.destroyContainer container, (err, data) ->
        return reject(err) if err
        resolve(data)

  if not Model.import_handleLine
    Model.import_handleLine = (ctx, line, options) ->
      return new Promise (resolve, reject) -> resolve()

  Model.importLine = (line, index, ctx, options, errors) ->
    return if not line?
    Model.import_handleLine ctx, line, options
    .catch (err) ->
      if err.status isnt 422
        throw err
      errors.push err
      # The real line number is i + 2 (file header and start line count at 0)
      Model.app.models.FileUploadError.create
        line: index + 2
        message: err.message
        fileUploadId: options.fileUpload

  Model.import_mapHandleLine = (ctx, fileContent, options) ->
    debug 'import_mapHandleLine'
    return new Promise (resolve, reject) ->
      errors = []
      Promise.mapSeries fileContent, (line, index) ->
        debug 'importLine of index: ', index
        Model.importLine line, index, ctx, options, errors
      .catch (unexpectedError) ->
        debug 'unexpectedError', unexpectedError
        return reject unexpectedError if unexpectedError
      .then ->
        debug 'errors', errors
        return reject(errors) if errors.length > 0
        debug 'all lines imported'
        resolve()

  Model.handle_import_error = (error, options, callback) ->
    return callback error if _.isArray error
    Model.app.models.FileUploadError.create
      line: null
      message: error.message
      fileUploadId: options.fileUpload
    .then (data) ->
      callback data
    .catch (err) ->
      callback err

  return
