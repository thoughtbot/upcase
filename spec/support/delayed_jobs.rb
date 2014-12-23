module DelayedJobsHelpers
  def stubbed_checkout
    build_stubbed(:checkout).tap do |checkout|
      Checkout.stubs(:find).with(checkout.id).returns(checkout)
    end
  end

  def stub_mail_method(klass, method_name)
    stub('mail', deliver_now: true).tap do |mail|
      klass.stubs(method_name => mail)
    end
  end

  def stub_mail_method_to_raise(klass, method_name, error)
    klass.stubs(method_name).raises(error)
  end
end

RSpec.configure do |c|
  c.include DelayedJobsHelpers
end
