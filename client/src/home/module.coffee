angular.module 'app.home', [
  'ngFileUpload'
]

.config ($stateProvider) ->
  $stateProvider
  .state 'home-main',
    url: '/home'
    controller: 'HomeMainCtrl'
    templateUrl: 'home/states/main/view.html'
