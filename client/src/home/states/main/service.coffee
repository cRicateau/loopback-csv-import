angular.module 'app.home'
.service 'UploadService', ($q, Upload) ->

  @uploadFile = (url, container) ->
    def = $q.defer()
    if _.isNull container.files
      def.reject()
      return def.promise

    data =
      url: url
      data:
        file: container.files

    Upload.upload data
    .then ->
      def.resolve()
    .catch (err) ->
      if err.error
        err = err.error
      def.reject()
    return def.promise

  return @
