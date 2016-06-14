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

  Invoice.import_handleLine = (ctx, line, uploadData) ->
    @import_validateLine line
    .then =>
      @createInvoice ctx, line

  Invoice.createInvoice = (ctx, line) ->
    Invoice.findOne
      where:
        invoiceId: line.InvoiceId
    , ctx
    .then (found) ->
      invoice =
        invoiceId: line.InvoiceId
        amount: line.Amount
      invoice.id = invoice.id if found
      Invoice.upsert invoice, ctx
