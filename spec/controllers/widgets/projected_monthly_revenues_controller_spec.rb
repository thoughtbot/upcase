require 'spec_helper'

describe Widgets::ProjectedMonthlyRevenuesController do
  it 'returns the total subscriber count for all plans' do
    calculator = stub(projected_monthly_revenue: 60)
    RevenueCalculator.stubs(new: calculator)

    get :show, format: :json

    expect(number_widget_first_value).to eq 60
    expect(json_response['item'].first['prefix']).to eq '$'
  end
end
