module DelayedJobsHelpers
  def stub_mail_method(klass, method_name)
    double("mail", deliver_now: true).tap do |mail|
      allow(klass).to receive(method_name).and_return(mail)
    end
  end
end

RSpec.configure do |c|
  c.include DelayedJobsHelpers
end
