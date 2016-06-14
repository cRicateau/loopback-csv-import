_ = require 'lodash'
moment = require 'moment'
Promise = require 'bluebird'

nullValues = ['', undefined, null]

cleanInput = (input) ->
  if input
    input = input.toLowerCase()
    input = input.trim()
  return input

getErrorMessage = (columnName, cellData, customErrorMessage) ->
  err = new Error "Unprocessable cell content in column #{columnName} where content is '#{cellData}' : #{customErrorMessage}"
  err.status = 422
  return err

validateInteger = (value) ->
  if typeof value is 'string' and /^(\-|\+)?[0-9]+$/.test value
    return isFinite Number value
  typeof value is 'number' and
    isFinite(value) and
    Math.floor(value) is value

validateFloat = (value) ->
  return /^(\-|\+)?([0-9]+(\.[0-9]+)?|Infinity)$/.test(value)

validatePercentage = (value) ->
  return validateFloat(value) and parseFloat(value) <= 100

validateDate = (value) ->
  return moment(value, 'DD/M/YYYY', true).isValid()

validate = (line, validationConfig) ->
  return new Promise (resolve, reject) =>
    return resolve() if not validationConfig or not line
    for cellName, cellContent of line
      if validationConfig[cellName]?.required and cellContent in @nullValues and validationConfig[cellName].required
        return reject(@getErrorMessage cellName, cellContent, "#{cellName} cannot be null")

      if validationConfig[cellName] and cellContent
        type = validationConfig[cellName].type
        switch type
          when 'integer'
            if not @validateInteger cellContent
              return reject(@getErrorMessage cellName, cellContent, "#{cellName} must be an integer")
          when 'float'
            if not @validateFloat cellContent
              return reject(@getErrorMessage cellName, cellContent, "#{cellName} must be a float")
          when 'date'
            if not @validateDate cellContent
              return reject(@getErrorMessage cellName, cellContent, "#{cellName} must be formatted as DD/MM/YYYY")
    return resolve()


module.exports =
  validate: validate
  validateDate: validateDate
  cleanInput: cleanInput
  getErrorMessage: getErrorMessage
  validateInteger: validateInteger
  nullValues: nullValues
  validateFloat: validateFloat
  validatePercentage: validatePercentage
