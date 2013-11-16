require 'spec_helper'

describe Widgets::TotalNewSubscriberCountsController do
  it 'returns the total subscriber count for all plans' do
    Timecop.freeze do
      metrics = stub(subscription_signups_since: [stub])
      Metrics.stubs(new: metrics)

      get :show, format: :json

      expect(metrics).to have_received(:subscription_signups_since).with(
        30.days.ago.to_date
      )
      expect(number_widget_first_value).to eq 1
    end
  end
end
