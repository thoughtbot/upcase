require 'spec_helper'

describe AnalyticsUpdater do
  describe 'unsubscribe' do
    let(:user) { create(:user) }
    let(:key) { ENV['SEGMENT_KEY'] }

    before :each do
      AnalyticsRuby.stubs(:init).with(secret: key)
      traits = { has_active_subscription: false }.merge(intercom_hash)
      AnalyticsRuby.stubs(:identify).with(user_id: user.id.to_s, traits: traits)
    end

    describe 'analytics enable' do
      before :each do
        @old_analytics = ENV['ANALYTICS']
        ENV['ANALYTICS'] = 'on'
      end

      after :each do
        ENV['ANALYTICS'] = @old_analytics
      end

      it 'should unsubscribe user' do
        updater = AnalyticsUpdater.new(user)
        updater.unsubscribe

        expect(AnalyticsRuby).
          to have_received(:init).with(secret: key)
        expect(AnalyticsRuby).
          to have_received(:identify).with(user_id: user.id.to_s, traits: { has_active_subscription: false }.
                                           merge(intercom_hash))
      end
    end

    describe 'analytics disabled' do
      before :each do
        @old_analytics = ENV['ANALYTICS']
        ENV['ANALYTICS'] = nil
      end

      after :each do
        ENV['ANALYTICS'] = @old_analytics
      end

      it 'should not update analytics if disabled' do
        updater = AnalyticsUpdater.new(user)
        updater.unsubscribe

        expect(AnalyticsRuby).to have_received(:init).never
        expect(AnalyticsRuby).to have_received(:identify).never
      end
    end
  end

  private

  def intercom_hash
    {
      'Intercom' => {
        userHash: OpenSSL::HMAC.hexdigest('sha256',
                                          ENV['INTERCOM_API_SECRET'],
                                          user.id.to_s)
      }
    }
  end
end
