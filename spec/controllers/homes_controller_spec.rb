require 'spec_helper'

describe HomesController do
  it 'redirects to Prime if the visitor is not logged in' do
    get :show

    response.should redirect_to prime_path
  end

  it 'redirects to products if the visitor is logged in' do
    sign_in

    get :show

    response.should redirect_to products_path
  end
end
