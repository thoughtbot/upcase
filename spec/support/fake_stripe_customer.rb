class FakeStripeCustomer
  attr_reader :subscriptions_called, :create_called, :create_options

  def subscriptions
    @subscriptions_called = true
    self
  end

  def create(options)
    @create_options = options
    @create_called = true
    OpenStruct.new(id: options[:plan])
  end
end
