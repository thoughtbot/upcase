require "rails_helper"

describe Api::V1::CompletionsController, "#show", type: :controller do
  it 'returns a 401 when users are not authenticated' do
    get :index
    expect(response.code).to eq "401"
  end
end
