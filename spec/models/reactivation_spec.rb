require "rails_helper"

describe Reactivation do
  describe '#fulfill' do
    it 'reactivates subscription' do
      subscription = spy

      reactivation = Reactivation.new(subscription: subscription)
      reactivation.fulfill

      expect(subscription).to have_received(:reactivate)
    end
  end
end
