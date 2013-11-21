require 'spec_helper'

describe Widgets::TotalCancellationsController do
  it 'returns the total number of cancellations' do
    metrics_instance = stub(canceled_subscriptions_since: 10)
    Metrics.stubs(new: metrics_instance)

    get :show, format: :json

    expect(number_widget_first_value).to eq 10
  end

end
