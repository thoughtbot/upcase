module StubRailsEnv
  def stub_rails_environment(env)
    inquirer = ActiveSupport::StringInquirer.new(env)
    allow(Rails).to receive(:env).and_return(inquirer)
  end
end

RSpec.configure do |config|
  config.include StubRailsEnv
end
