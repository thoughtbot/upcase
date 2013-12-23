require 'spec_helper'

describe SubscriptionCountReport do
  before do
    Timecop.freeze(Time.zone.parse('2013-10-28 10:00:00'))
  end

  after do
    Timecop.return
  end

  describe '#rows' do
    it 'returns rows of daily subscription counts' do
      user_subscribed_three_days_ago = create_user_with_subscription(3.days.ago)
      user_subscribed_two_days_ago = create_user_with_subscription(2.days.ago)
      user_subscribed_one_day_ago = create_user_with_subscription(1.day.ago)

      unsubscribe_user(user_subscribed_three_days_ago, Time.zone.today)

      report_generator = SubscriptionCountReport.new
      csv = report_generator.rows

      report_fixture = CSV.open(File.join(Rails.root, 'spec', 'fixtures', 'reports', 'test_report.csv')).read()

      expect(csv).to eq report_fixture
    end
  end

  def create_user_with_subscription(subscription_date)
    subscription = create(:subscription, created_at: subscription_date)
    user = create(:user, subscription: subscription, created_at: subscription_date)
    user
  end

  def unsubscribe_user(user, subscription_date)
    user.subscription.update(deactivated_on: subscription_date)
  end
end
