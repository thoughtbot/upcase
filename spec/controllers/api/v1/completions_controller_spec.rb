require 'spec_helper'

describe Api::V1::CompletionsController, '#show' do
  it 'returns a 401 when users are not authenticated' do
    get :index
    response.code.should eq '401'
  end
end
