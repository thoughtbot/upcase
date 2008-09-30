set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

before "deploy:setup", "db:password"

namespace :deploy do
  desc "Default deploy - updated to run migrations"
  task :default do
    set :migrate_target, :latest
    update_code
    migrate
    symlink
    restart
  end
  desc "Start the mongrels"
  task :start do
    send(run_method, "cd #{deploy_to}/#{current_dir} && #{mongrel_rails} cluster::start --config #{mongrel_cluster_config}")
  end
  desc "Stop the mongrels"
  task :stop do
    send(run_method, "cd #{deploy_to}/#{current_dir} && #{mongrel_rails} cluster::stop --config #{mongrel_cluster_config}")
  end
  desc "Restart the mongrels"
  task :restart do
    send(run_method, "cd #{deploy_to}/#{current_dir} && #{mongrel_rails} cluster::restart --config #{mongrel_cluster_config}")
  end
  desc "Run this after every successful deployment" 
  task :after_default do
    cleanup
  end
end

namespace :db do
  desc "Create database password in shared path" 
  task :password do
    set :db_password, Proc.new { Capistrano::CLI.password_prompt("Remote database password: ") }
    run "mkdir -p #{shared_path}/config" 
    put db_password, "#{shared_path}/config/dbpassword" 
  end
end
