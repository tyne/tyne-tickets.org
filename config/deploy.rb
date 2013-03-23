require "rvm/capistrano"
require "bundler/capistrano"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "tyne-tickets.org"
set :repository,  "git@github.com:tyne/tyne-tickets.org.git"

set :scm, :git

role :web, "198.211.115.73"                          # Your HTTP server, Apache/etc
role :app, "198.211.115.73"                          # This may be the same as your `Web` server
role :db,  "198.211.115.73", :primary => true # This is where Rails migrations will run

set :rails_env, 'production'
set :branch, 'master'

set :deploy_via, :remote_cache
set :use_sudo, false
set :user, "app"
set :port, 22
set :git_enable_submodules, 1
set :deploy_to, "/home/#{user}/#{application}"

set :rvm_ruby_string, "1.9.3@tyne"

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :assets do
    run "cd #{release_path} && source $HOME/.bash_profile && bundle exec rake assets:precompile RAILS_ENV=production"
  end
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

after 'bundle:install', 'deploy:after_hook'
after 'deploy:finalize_update', 'deploy:assets'
