# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'loopback-csv-import'
set :repo_url, 'https://github.com/cRicateau/loopback-csv-import.git'
set :scm, :git
set :stages, [:staging]
set :default_stage, :staging
set :ssh_options, { :forward_agent => true }
set :format, :pretty
set :keep_releases, 3
set :pty, true
set :linked_dirs, %w{node_modules}
set :linked_files, %w{src/config.json}

namespace :deploy do

  desc "Install dependencies"
  task :updated do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{release_path} && npm install"
    end
  end

  desc "Restart application"
  task :finished do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{current_path} && NODE_ENV=#{fetch(:env)} npm restart"
    end
  end
end

desc "Start application"
task :start do
  on roles(:app), in: :sequence, wait: 5 do
    execute "cd #{current_path} && npm start"
  end
end
