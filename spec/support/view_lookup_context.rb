RSpec.configure do |config|
  config.before type: :view do
    view.lookup_context.prefixes << "application"
  end
end
