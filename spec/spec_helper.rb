RSpec.configure do |config|
  config.order = :random

  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :mocha
end
