require 'spec_helper'

describe Api::V1::UsersController, '#show', type: :controller do
  it 'returns a 401 when users are not authenticated' do
    get :show
    expect(response.code).to eq "401"
  end
end
