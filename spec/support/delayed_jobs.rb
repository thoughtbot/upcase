module DelayedJobsHelpers
  def stubbed_purchase
    build_stubbed(:section_purchase).tap do |purchase|
      Purchase.stubs(:find).with(purchase.id).returns(purchase)
    end
  end

  def stub_mail_method(method_name)
    stub('mail', deliver: true).tap do |mail|
      Mailer.stubs(method_name => mail)
    end
  end

  def stub_mail_method_to_raise(method_name, error)
    Mailer.stubs(method_name).raises(error)
  end
end

RSpec.configure do |c|
  c.include DelayedJobsHelpers
end
