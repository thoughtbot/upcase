require 'spec_helper'

describe SubscriberEngagement do
  describe '#engagement_score' do
    it 'is 0 for a newly-created user' do
      engagement = build_engagement
      expect(engagement.engagement_score).to eq 0
    end

    it 'is 20 if a user has authenticated with Learn to access the forum' do
      engagement = build_engagement do |user|
        OauthAccessToken.stubs(:for_user).with(user).returns(stub('token'))
      end

      expect(engagement.engagement_score).to eq 20
    end

    it 'is 20 if a user has claimed something in the last 30 days' do
      engagement = build_engagement do |user|
        create(:purchase, user: user)
      end

      expect(engagement.engagement_score).to eq 20
    end

    it 'is 60 if a user has enrolled in a workshop in the last 30 days (40 for workshop, plus 20 for the claim)' do
      engagement = build_engagement do |user|
        create_subscriber_purchase(:section, user)
      end

      expect(engagement.engagement_score).to eq 60
    end

    it 'is 20 if a user has taken more than 2 workshops' do
      engagement = build_engagement do |user|
        Timecop.travel(60.days.ago) do
          3.times do
            create_subscriber_purchase(:section, user)
          end
        end
      end

      expect(engagement.engagement_score).to eq 20
    end
  end

  describe '#count_of_workshops_taken' do
    it 'is zero with a non-section claim' do
      engagement = build_engagement do |user|
        create(:purchase, user: user)
      end

      expect(engagement.count_of_workshops_taken).to eq 0
    end

    it 'is one with a section claim' do
      engagement = build_engagement do |user|
        create_subscriber_purchase(:section, user)
      end

      expect(engagement.count_of_workshops_taken).to eq 1
    end
  end

  describe '#date_of_last_workshop_claim' do
    it "returns the date that a user most-recently claimed a workshop" do
      engagement = build_engagement do |user|
        create_subscriber_purchase(:section, user)
        Timecop.travel(Date.yesterday) do
          create_subscriber_purchase(:section, user)
        end
      end

      expect(engagement.date_of_last_workshop_claim).to eq Time.zone.today
    end
  end

  describe '#name' do
    it 'delegates to user' do
      user = build_stubbed(:user)
      expect(build_engagement_for(user).name).to eq user.name
    end
  end

  describe '#email' do
    it 'delegates to user' do
      user = build_stubbed(:user)
      expect(build_engagement_for(user).email).to eq user.email
    end
  end

  def build_engagement
    user = build(:user)
    yield user if block_given?
    build_engagement_for(user)
  end

  def build_engagement_for(user)
    SubscriberEngagement.new(user)
  end
end
