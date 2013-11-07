require 'spec_helper'

describe Metrics do
  describe '#subscription_signups_since' do
    it 'returns subscriptions created after the date provided' do
      subscription_relation = stub('subscription relation', where: nil)

      Timecop.freeze do
        date = 30.days.ago.to_date
        Metrics.new(subscription_relation).subscription_signups_since(date)

        expect(subscription_relation).to have_received(:where).with(created_at: (date..Time.zone.now))
      end
    end
  end
end
