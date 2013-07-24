require 'spec_helper'

describe SubscriptionMailer do
  describe '.welcome_to_prime' do
    it 'is sent to the user' do
      user = create(:subscription).user
      email = SubscriptionMailer.welcome_to_prime(user)
      expect(email.to).to include(user.email)
      expect(email).to have_body_text(/Hi #{user.first_name}/)
    end

    it 'comes from the mentor' do
      user = create(:subscription).user
      email = SubscriptionMailer.welcome_to_prime(user)

      expect(email.from).to include(user.mentor.email)
      expect(email.body).to include(user.mentor.first_name)
      expect(email.body).to include(url_encode(user.mentor.email))
    end
  end

  describe '.unsubscription_survey' do
    it 'sends a survey to the user who just unsubscribed' do
      user = create(:user)
      email = SubscriptionMailer.unsubscription_survey(user)
      expect(email.to).to include(user.email)
      expect(email).to have_body_text(/Hi #{user.first_name}/)
      expect(email).to have_body_text(/just unsubscribed/)
    end
  end
end

