# Rails 2 doesn't like mocks

# This callback will run before every request to a mock in development mode, 
# or before the first server request in production. 

Rails.configuration.to_prepare do
  Dir[File.join(RAILS_ROOT, 'test', 'mocks', RAILS_ENV, '*.rb')].each do |f|
    load f
  end
end
