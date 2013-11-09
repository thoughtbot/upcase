require 'spec_helper'

describe Metrics do
  describe '#subscription_signups_since' do
    it 'returns subscriptions created after the date provided' do
      Timecop.freeze do
        date = 30.days.ago.to_date
        Metrics.new(subscription_relation).subscription_signups_since(date)

        expect(subscription_relation).to have_received(:where).with(created_at: (date..Time.zone.now))
      end
    end
  end

  describe '#canceled_subscriptions_since' do
    it 'returns the subscriptions that have been canceled since a given date' do
      Timecop.freeze do
        date = 30.days.ago.to_date
        Metrics.new(subscription_relation).canceled_subscriptions_since(date)

        expect(subscription_relation).to have_received(:where).with(deactivated_on: (date..Time.zone.today))
      end
    end
  end

  def subscription_relation
    @subscription_relation ||= stub('subscription relation', where: nil)
  end
end
