module ViewStubs
  def view_stubs(method_name)
    Mocha::Configuration.allow(:stubbing_non_existent_method) do
      view.stubs(method_name)
    end
  end
end

RSpec.configure do |config|
  config.include ViewStubs
end
