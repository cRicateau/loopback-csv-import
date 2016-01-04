winston = require('winston');

logger = new (winston.Logger)({
  transports: [
    new (winston.transports.File)({
      name: 'info-file',
      filename: 'filelog-info.log',
      level: 'info'
    }),
    new (winston.transports.File)({
      name: 'error-file',
      filename: 'filelog-error.log',
      level: 'error'
    })
  ]
});

module.exports = function() {
  return function(err, req, res, next) {
    logger.error(err.stack);
    next(err);
  }
};
