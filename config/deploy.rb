require "bundler/capistrano"

set :application, "archive"
set :user, "mrnugget"
set :domain, "howlingvibes.com"

set :repository,  "git@github.com:mrnugget/archive.git"
set :deploy_to, "/home/#{user}/rails_apps"
default_run_options[:pty] = true 

set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :deploy_via, :remote_cache
set :use_sudo, true
set :rails_env, :production

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, domain
role :app, domain
role :db, domain 

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# after "deploy:update_code", :bundle_install
# desc "install the necessary prerequisites"
# task :bundle_install, :roles => :app do
#   run "cd #{release_path} && bundle install --deployment"
# end
