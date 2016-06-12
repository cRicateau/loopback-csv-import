_ = require 'lodash'
async = require 'async'
crypto = require 'crypto'
debug = require('debug') 'loopback-csv-example:xls-upload'
fastcsv = require 'fast-csv'
magic = require 'mmmagic'
path = require 'path'
XLS = require 'xlsjs'
XLSX = require 'xlsx'
Promise = require 'bluebird'

importService = require '../../server/services/csv-import-utils/csv-import-utils'

module.exports = (Model, options) ->

  Model.prepareInput = (input) ->
    debug 'prepareInput'
    return new Promise (resolve, reject) ->
      data = []
      csv = XLS.utils.sheet_to_csv(input.Sheets[input.SheetNames[0]])
      fastcsv.fromString csv, {headers: false}
      .on 'data', (item) -> data.push item
      .on 'end', -> return resolve data

  if not Model.import_filterRows
    Model.import_filterRows = (matrix) ->
      debug 'import_filterRows', matrix
      return matrix

  if not Model.import_convertToObject
    Model.import_convertToObject = (matrix) ->
      debug 'import_convertToObject'
      header = matrix[0]
      return _(matrix)
      .filter (row, rowNumber) -> return rowNumber isnt 0
      .map (row) ->
        return _.reduce row, (db, item, rowNumber) ->
          db[header[rowNumber]] = item
          return db
        , {}
      .value()

  if not Model.check_header
    Model.check_header = (matrix) ->
      debug 'check_header'
      if Array.isArray options?.requiredHeaders
        headers = matrix[0]
        missingHeaderItems = _.difference options.requiredHeaders, headers
        if missingHeaderItems.length > 0
          throw new Error "The following columns are missing in the excel file: #{missingHeaderItems.join(', ')}"
        else
          return matrix
      return matrix

  if not Model.create_meta_object
    Model.create_meta_object = (ctx, options) -> return Promise.resolve {}

  if not Model.clean_records_data
    Model.clean_records_data = (ctx, object) -> return Promise.resolve()
  Model.importLine = (line, index, ctx, options) ->
    return if not line?
    Model.import_handleLine ctx, line, options
    .catch (err) ->
      if err.status isnt 421
        throw err
      errors.push err
      # The real line number is i + 2 (file header and start line count at 0)
      Model.app.models.FileUploadError.create
        line: index + 2
        message: err.message
        fileUploadId: options.fileUpload

  Model.import_process = (ctx, container, file, options, callback) ->
    debug 'import_process', file, options
    fileContent = []
    filename = path.join Model.app.datasources.container.settings.root, container, file
    m = new magic.Magic(magic.MAGIC_MIME_TYPE)
    m.detectFileSync = Promise.promisify m.detectFile.bind m
    metaObject = {}
    Model.create_meta_object ctx, options
    .then (object) ->
      metaObject = object
      Model.clean_records_data ctx, metaObject
    .then ->
      m.detectFileSync filename
    .then (result) ->
      Model.check_file_type result, filename
    .then Model.prepareInput
    .then Model.import_filterRows
    .then Model.check_header
    .then Model.import_convertToObject
    .then (matrix) ->
      Model.import_mapHandleLine ctx, matrix, options, metaObject
    .then ->
      return callback()
    .catch (error) ->
      Model.handle_import_error error, options, callback

  Model.check_file_type = (result, filename) ->
    return new Promise (resolve, reject) ->
      if (/^application\/vnd.ms-excel$/g).test result
        resolve XLS.readFile filename
      else if (/application\/vnd.openxmlformats-officedocument.spreadsheetml.sheet$/g).test result
        resolve XLSX.readFile filename
      else
        reject message: 'File is not a valid excel'
