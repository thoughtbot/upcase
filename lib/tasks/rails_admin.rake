# Include the rails_admin initializer when loading the environment.
# This is disabled by default, but prevents testing of rails_admin
# customisations. It can still be manually disabled by setting the
# SKIP_RAILS_ADMIN_INITIALIZER environment variable to 'true'
Rake::Task['environment'].prerequisites.delete 'rails_admin:disable_initializer'
