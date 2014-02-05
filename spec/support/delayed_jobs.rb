module DelayedJobsHelpers
  def stubbed_purchase
    build_stubbed(:workshop_purchase).tap do |purchase|
      Purchase.stubs(:find).with(purchase.id).returns(purchase)
    end
  end

  def stub_mail_method(klass, method_name)
    stub('mail', deliver: true).tap do |mail|
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
