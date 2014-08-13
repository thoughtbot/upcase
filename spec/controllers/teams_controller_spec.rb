require "rails_helper"

describe TeamsController do
  it_behaves_like 'must be team member' do
    def perform_request
      get :edit
    end
  end
end
