_ = require 'lodash'
async = require 'async'
csv = require 'fast-csv'
debug = require('debug') 'loopback-csv-example:csv-upload'
fs = require 'fs'
iconv = require 'iconv-lite'
charsetDetector = require 'node-icu-charset-detector'
magic = require 'mmmagic'
path = require 'path'
Promise = require 'bluebird'

importService = require '../../server/services/import-utils'

module.exports = (Model, options) ->

  if not Model.import_validateLine
    Model.import_validateLine = (line) ->
      if options?.validators
        return importService.validate line, options.validators
      return new Promise (resolve, reject) -> resolve()

  detectFileEncoding = (file) ->
    buffer = fs.readFileSync file
    charset = charsetDetector.detectCharset buffer
    return charset.toString()

  Model.check_file_type = (fileType) ->
    return new Promise (resolve, reject) ->
      if (/application\/(csv|excel|vnd\.msexcel|vnd\.ms\-excel)|text\/plain/g).test fileType
        resolve()
      else
        reject message: 'File is not a valid csv'

  Model.getCsvStream = (options) ->
    return csv(options) if options
    stream = csv
      delimiter: ';'
      headers: true
      trim: true
      ignoreEmpty: true
    return stream

  Model.handleCsvStream = (ctx, filename, options, callback) ->
    fileContent = []
    stream = Model.getCsvStream()
    stream.on 'data', (data) ->
      fileContent.push data

    stream.on 'error', (error) ->
      Model.handle_import_error error, options, callback

    stream.on 'end', ->
      Model.import_mapHandleLine ctx, fileContent, options
      .then ->
        callback()
      .catch (error) ->
        Model.handle_import_error error, options, callback
    try
      encoding = detectFileEncoding filename
      fs.createReadStream filename
      .pipe iconv.decodeStream encoding
      .pipe stream
    # An empty file will raise an encoding detecting error
    catch err
      Model.handle_import_error err, options, callback

  Model.import_process = (ctx, container, file, options, callback) ->
    debug 'import_process', file, options
    return new Promise (resolve, reject) ->
      filename = path.join Model.app.datasources.container.settings.root, container, file
      m = new magic.Magic(magic.MAGIC_MIME_TYPE)
      m.detectFileSync = Promise.promisify m.detectFile.bind m
      m.detectFileSync filename
      .then (fileType) ->
        Model.check_file_type fileType
      .then ->
        Model.handleCsvStream ctx, filename, options, (err) ->
          return reject err if err
          resolve()
      .catch (error) ->
        Model.handle_import_error error, options, (err) ->
          return reject err if err
          resolve()

return
