angular.module 'app', [
# Vendors
  'ng'
  'ngAnimate'
  'ngCookies'
  'ngSanitize'
  'pascalprecht.translate'
  'ui.bootstrap'
  'ui.router'

# App submodules
  'app.template'
  'app.services'
  'app.home'
]

.config ($translateProvider) ->
  $translateProvider
  .determinePreferredLanguage()
  .useStaticFilesLoader
      prefix: 'static/i18n/locale-'
      suffix: '.json'
  .preferredLanguage 'en'
  .addInterpolation '$translateMessageFormatInterpolation'
  .useSanitizeValueStrategy 'escaped'


.config ($urlRouterProvider) ->
  $urlRouterProvider.otherwise '/home'

.run ->
  return
