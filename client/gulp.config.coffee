config = {}

config.minify = false
if process.env.NODE_ENV == 'production'
  config.minify = true
if process.env.NODE_ENV == 'staging'
  config.minify = true

config.livereload = false
config.lint = true

config.input = {}
# Where sources are located
config.input.path = 'src'
# Main index file
config.input.jade = "#{config.input.path}/index.jade"
# Where to find templates
config.input.template = [
  "#{config.input.path}/*.jade"
  "#{config.input.path}/**/*.jade"
]
# Where to find coffee files
config.input.coffee = [
  "#{config.input.path}/{,**/}*.coffee"
  "!#{config.input.path}/{,**/}*.test.coffee"
]

# Where to find less file(s)
config.input.less = {}
config.input.less.main = "#{config.input.path}/style/main.less"
config.input.less.watch = [
  "#{config.input.path}/**/*.less"
]

config.input.vendor = {}
config.input.vendor.watch = [
  'bower.json'
  'bower_components/*'
]

config.input.replace = {}
config.input.replace.enabled = false
config.input.replace.patterns = []

config.input.manifest = {}
config.input.manifest.enabled = false
config.input.manifest.source = 'www/**'
config.input.manifest.settings =
  filename: 'app.manifest'
  cache: undefined
  exclude: 'app.manifest'
  network: ['*']
  fallback: undefined
  preferOnline: undefined
  hash: true

# Static files
config.input.static = {}
# Can add keys in both input and output to add static profile
config.input.static.fonts = [
  'bower_components/font-awesome/fonts/*'
  'bower_components/bootstrap/fonts/*'
]
config.input.static.i18n = [
  "#{config.input.path}/static/i18n/*"
]
config.input.static.i18nAngular = [
  "bower_components/angular-i18n/angular-locale_en.js"
  "bower_components/angular-i18n/angular-locale_fr.js"
]
config.input.static.images = [
]
config.input.static.scripts = [
]
config.input.static.styles = [
]

# Loopback configuration
config.input.loopback = {}
config.input.loopback.watch = [
  "#{__dirname}/../server/*"
  "#{__dirname}/../server/**/*"
  "#{__dirname}/../common/**/*"
]
config.input.loopback.enabled = true
config.input.loopback.server = "#{__dirname}/../server/server.coffee"
config.input.loopback.url = 'api/'
config.input.loopback.replate = {}
config.input.loopback.replate.enabled = false

config.output = {}
# Output directory
config.output.path = 'www'

config.output.script = "#{config.output.path}/script"

config.output.application = 'application.js'

config.output.template = {}
config.output.template.filename = 'templates.js'
config.output.template.module = 'app.template'

config.output.vendor = 'vendor.js'

config.output.manifest = config.output.path

config.output.static = {}
config.output.static.fonts = "#{config.output.path}/style/fonts"
config.output.static.i18n = "#{config.output.path}/static/i18n"
config.output.static.i18nAngular = "#{config.output.path}/static/i18n/angular"
config.output.static.images = "#{config.output.path}/style/images"
config.output.static.scripts = "#{config.output.path}/script"
config.output.static.styles = "#{config.output.path}/style"

config.output.loopback = {}
config.output.loopback.filename = 'services.js'
config.output.loopback.path = "#{config.output.path}/script"
config.output.loopback.module = 'app.services'

config.output.less = "#{config.output.path}/style"

module.exports = config
