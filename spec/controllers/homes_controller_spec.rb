require "rails_helper"

describe HomesController do
  it 'redirects to the landing page if the visitor is not logged in' do
    get :show

    expect(response).to redirect_to subscribe_path
  end

  it 'redirects to products if the visitor is logged in' do
    sign_in

    get :show

    expect(response).to redirect_to dashboard_path
  end
end
