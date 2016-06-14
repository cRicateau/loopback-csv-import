angular.module 'app.home'
.controller 'HomeMainCtrl', ($scope, $interval, UploadService, FileUpload) ->
  $scope.uploadFile = ->
    UploadService.uploadFile $scope.form.uploadUrl, $scope.form
    .then ->
      currentCheck = $interval($scope.checkStatus, 2500, 0) unless currentCheck

  $scope.form =
      name: 'Invoice'
      files: null
      loading: false
      uploadUrl: 'api/invoices/upload'

  currentCheck = null
  $scope.checkStatus = ->
    FileUpload.findOne
      filter:
        where:
          fileType: $scope.form.name
        order: 'date DESC'
        include: [
          'errors'
        ]
    .$promise
    .then (upload) ->
      $scope.lastUpdate = upload
      unless upload.status is 'PENDING'
        $interval.cancel(currentCheck)
        currentCheck = null

  $scope.checkStatus()
  currentCheck = $interval($scope.checkStatus, 5000, 0)
