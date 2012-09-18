require 'spec_helper'

describe Mailer, 'registration_notification' do
  around do |example|
    Timecop.freeze Date.parse('2012-09-12') do
      example.run
    end
  end

  it 'includes starts_on and ends_on in the email body' do
    registration = build_registration

    email = Mailer.registration_notification(registration)
    email.body.should include registration.section.date_range
  end

  it 'includes section city in the email body' do
    registration = build_registration_in 'San Antonio'

    email = Mailer.registration_notification(registration)
    email.body.should include 'San Antonio'
  end

  def build_registration
    build_stubbed(:registration)
  end

  def build_registration_in(city)
    build_registration.tap do |registration|
      registration.section.city = city
    end
  end
end
