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

  # Clean up old releases after each deployment
  after "deploy", "deploy:cleanup"

  before :deploy do
    if real_revision.empty?
      raise "The tag, revision, or branch #{revision} does not exist."
    end
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


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
