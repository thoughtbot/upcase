require 'spec_helper'

describe Show do
  it_behaves_like 'a class inheriting from Product'

  it { should have_many(:videos).dependent(:destroy) }

  describe '#licenses_for' do
    it 'has no licenses for non-subscribers' do
      user = build_stubbed(:user)
      user.stubs(:has_active_subscription?).returns(false)
      show = build(:show)

      expect(show.licenses_for(user)).to be_empty
    end

    it 'has a subscriber license for subscribers' do
      user = build_stubbed(:user)
      user.stubs(:has_active_subscription?).returns(true)
      show = build(:show)

      expect(show.licenses_for(user).first).to be_a(SubscriberLicense)
    end
  end
end
