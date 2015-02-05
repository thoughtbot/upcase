module DelayedJobsHelpers
  def stubbed_checkout
    build_stubbed(:checkout).tap do |checkout|
      allow(Checkout).to receive(:find).with(checkout.id).and_return(checkout)
    end
  end

  def stub_mail_method(klass, method_name)
    double("mail", deliver_now: true).tap do |mail|
      allow(klass).to receive(method_name).and_return(mail)
    end
  end

  def stub_mail_method_to_raise(klass, method_name, error)
    allow(klass).to receive(method_name).and_raise(error)
  end
end

RSpec.configure do |c|
  c.include DelayedJobsHelpers
end
