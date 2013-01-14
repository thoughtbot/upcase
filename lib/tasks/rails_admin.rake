namespace :rails_admin do
  desc 'Enable rails_admin initializer'
  task :enable_initializer do
    ENV['SKIP_RAILS_ADMIN_INITIALIZER'] ||= 'false'
  end
end

# rails_admin is disabled by default. To enable it for the cucumber features,
# the SKIP_RAILS_ADMIN_INITIALIZER must be set *before* the environment task
# runs.
Rake::Task['default'].prerequisites.prepend 'rails_admin:enable_initializer'
