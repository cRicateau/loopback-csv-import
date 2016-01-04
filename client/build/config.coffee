config = {}

config.minify = false
if process.env.NODE_ENV == 'production'
  config.minify = true
if process.env.NODE_ENV == 'staging'
  config.minify = true

config.input = {}
# Where sources are located
config.input.path = 'src'
# Where the theme is located
config.input.theme = '../theme'
# Main index file
config.input.jade = "#{config.input.path}/index.jade"
# Where to find templates
config.input.template = [
  "#{config.input.path}/*.jade"
  "#{config.input.path}/**/*.jade"
]
# Where to find coffee files
config.input.coffee = [
  "#{config.input.path}/*.coffee"
  "#{config.input.path}/**/*.coffee"
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

# Static files
config.input.static = {}
# Can add keys in both input and output to add static profile
config.input.static.fonts = [
  "#{config.input.theme}/www/fonts/*"
]
config.input.static.i18n = [
  "#{config.input.path}/static/i18n/*"
]
config.input.static.ie8js = [

]
config.input.static.ie8css = [

]

# Loopback configuration
config.input.loopback = {}
config.input.loopback.enabled = false
config.input.loopback.server = '../server/server.coffee'
config.input.loopback.url = 'api/'

config.output = {}
# Output directory
config.output.path = 'www'

config.output.script = "#{config.output.path}/script"

config.output.application = 'application.js'

config.output.template = {}
config.output.template.filename = 'templates.js'
config.output.template.module = 'app.template'

config.output.vendor = 'vendor.js'

config.output.static = {}
config.output.static.fonts = "#{config.output.path}/fonts"
config.output.static.i18n = "#{config.output.path}/static/i18n"
config.output.static.ie8js = "#{config.output.path}/script"
config.output.static.ie8css = "#{config.output.path}/style"

config.output.loopback = {}
config.output.loopback.filename = 'services.js'
config.output.loopback.path = "#{config.output.path}/script"

config.output.less = "#{config.output.path}/style"

module.exports = config
