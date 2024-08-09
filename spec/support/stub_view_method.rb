module ViewStubs
  def view_stubs(method_name)
    allow(view).to receive(method_name)
  end

  def view_stub_with_return(*values)
    values.each do |value|
      value.each do |method_name, return_value|
        allow(view).to receive(method_name)
          .and_return(return_value)
      end
    end
  end
end

RSpec.configure do |config|
  config.include ViewStubs
end
