require 'spec_helper'

describe PurchaseMailer do
  describe '.welcome_to_prime' do
    it 'is sent to the user' do
      user = create(:subscription).user
      email = PurchaseMailer.welcome_to_prime(user)
      expect(email.to).to include(user.email)
      expect(email).to have_body_text(/Hi #{user.first_name}/)
    end

    it 'comes from the mentor' do
      user = create(:subscription).user
      email = PurchaseMailer.welcome_to_prime(user)

      expect(email.from).to include(user.mentor.email)
      expect(email.body).to include(user.mentor.first_name)
      expect(email.body).to include(url_encode(user.mentor.email))
    end
  end

  describe '.follow_up' do
    include Rails.application.routes.url_helpers

    it "mentions the workshop name" do
      workshop = create(:workshop, name: "Foo bar")

      expect(follow_up_for(workshop: workshop).body).to include "Foo bar"
    end

    it "is from learn@thoughtbot.com" do
      expect(follow_up_for.from).to eq(%w(learn@thoughtbot.com))
    end

    it "mentions the workshop name in the subject" do
      workshop = create(:workshop, name: "Foo bar")

      expect(follow_up_for(workshop: workshop).subject).to include "Foo bar"
    end

    it "is sent to the follow up email" do
      follow_up = create(:follow_up)

      expect(follow_up_for(follow_up: follow_up).to).to eq([follow_up.email])
    end

    it "links to the workshop" do
      workshop = create(:workshop)

      expect(follow_up_for(workshop: workshop).body).to include workshop_url(workshop)
    end

    def follow_up_for(options = {})
      options[:follow_up] ||= create(:follow_up)
      options[:workshop] ||= create(:workshop)
      section = create(:section, workshop: options[:workshop])

      PurchaseMailer.follow_up options[:follow_up], section
    end
  end
end
