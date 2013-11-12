require 'spec_helper'

describe Widgets::TotalChurnsController do
  it 'returns the total churn count for all plans' do
    plans = [create(:individual_plan), create(:team_plan)]
    total_churn = stub(current: 10)
    TotalChurn.stubs(new: total_churn)

    get :show, format: :json

    expect(TotalChurn).to have_received(:new).with(plans)
    expect(number_widget_first_value).to eq 10
  end
end
