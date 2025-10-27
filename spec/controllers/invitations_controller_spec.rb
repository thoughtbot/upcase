require "rails_helper"

RSpec.describe InvitationsController do
  it_behaves_like "must be team owner" do
    def perform_request
      invitation = double("invitation", deliver: true)
      allow(Invitation).to receive(:new).and_return(invitation)

      post :create, params: {invitation: {email: "somebody@example.com"}}
    end

    def authorize
      redirect_to(edit_team_path)
    end
  end
end
