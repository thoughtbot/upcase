When 'the reminder email rake task runs' do
  require 'rake'
  rake = Rake::Application.new
  Rake.application = rake
  Rake.application.rake_require 'tasks/reminders'
  Rake::Task.define_task(:environment)
  rake['reminders:section'].invoke
end
