server 'whateverdomain', user: 'www-data', roles: %w{app web}

set :deploy_to, "/var/www/loopback-csv-import"
set :env, "prod"
set :branch, "develop"
