require 'spec_helper'

describe AnalyticsUpdater do
  describe 'unsubscribe' do
    let(:user) { create(:user) }

    around(:each) do |example|
      ClimateControl.modify(
        SEGMENT_KEY: segment_key,
        INTERCOM_API_SECRET: intercom_secret) do
          example.run
        end
    end

    before :each do
      AnalyticsRuby.stubs(:init).with(secret: segment_key)
      traits = { has_active_subscription: false }.merge(intercom_hash)
      AnalyticsRuby.stubs(:identify).with(user_id: user.id.to_s, traits: traits)
    end

    describe 'analytics enable' do
      around(:each) do |example|
        ClimateControl.modify ANALYTICS: 'on' do
          example.run
        end
      end

      it 'should unsubscribe user' do
        updater = AnalyticsUpdater.new(user)
        updater.unsubscribe

        expect(AnalyticsRuby).
          to have_received(:init).with(secret: segment_key)
        expect(AnalyticsRuby).
          to have_received(:identify).with(
            user_id: user.id.to_s,
            traits: { has_active_subscription: false }.merge(intercom_hash)
        )
      end
    end

    describe 'analytics disabled' do
      around(:each) do |example|
        ClimateControl.modify ANALYTICS: nil do
          example.run
        end
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
        userHash: OpenSSL::HMAC.hexdigest(
          'sha256',
          intercom_secret,
          user.id.to_s)
      }
    }
  end

  def segment_key
    'segment-key'
  end

  def intercom_secret
    'secret'
  end
end
