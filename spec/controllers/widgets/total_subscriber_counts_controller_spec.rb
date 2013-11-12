require 'spec_helper'

describe Widgets::TotalSubscriberCountsController do
  it 'returns the total subscriber count for all plans' do
    create(:user, :with_subscription)
    create(:user, :with_team_subscription)

    get :show, format: :json

    expect(number_widget_first_value).to eq 2
  end
end
