require "bundler/capistrano"

set :application, "angelnvc.com"
set :repository,  "git@github.com:fredwu/angel_nest.git"

set :scm, "git"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, "nginx_passenger"

ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"],"xiaoningec2key.pem")]
set :user, "ubuntu"
set :branch, "master"
set :deploy_via, :remote_cache

set :deploy_to, "/var/www"

role :web, "angelnvc.com"                          # Your HTTP server, Apache/etc
role :app, "angelnvc.com"                          # This may be the same as your `Web` server
role :db,  "angelnvc.com", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

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

#RVM plugin, allow cap to find bundler etc in path
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
#set :rvm_ruby_string, 'rvm@rails3'        # Or whatever env you want it to run in.
