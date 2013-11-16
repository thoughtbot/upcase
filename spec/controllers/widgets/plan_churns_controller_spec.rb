require 'spec_helper'

describe Widgets::PlanChurnsController do
  it 'returns the current churn for the requested plan' do
    plan = stub(current_churn: 10)
    PlanFinder.stubs(where: [plan])

    get :show, format: :json, sku: 'sku'

    expect(PlanFinder).to have_received(:where).with(sku: 'sku')
    expect(number_widget_first_value).to eq 10
  end
end
