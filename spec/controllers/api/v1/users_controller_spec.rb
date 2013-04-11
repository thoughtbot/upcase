require 'spec_helper'

describe Api::V1::UsersController, '#show' do
  it 'returns a 401 when users are not authenticated' do
    get :show
    response.code.should == '401'
  end
end
