require 'bundler/capistrano'

set :application, 'archive'
set :user, 'mrnugget'
set :domain, 'howlingvibes.com'

set :repository,  'git@github.com:mrnugget/archive.git'
set :deploy_to, "/home/#{user}/rails_apps/#{application}"
default_run_options[:pty] = true

set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :deploy_via, :remote_cache
set :use_sudo, false
set :rails_env, :production

role :web, domain
role :app, domain
role :db, domain, :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# Copying my production database.yml from shared/config to current/config
namespace :db do
  task :copy_db_config, :except => { :no_release => true }, :role => :app do
    run "cp -f #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

after 'deploy:finalize_update', 'db:copy_db_config'
