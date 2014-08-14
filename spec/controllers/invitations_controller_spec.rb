require "rails_helper"

describe InvitationsController do
  it_behaves_like 'must be team member' do
    def perform_request
      invitation = stub('invitation', deliver: true)
      Invitation.stubs(:new).returns(invitation)

      post :create, invitation: { email: 'somebody@example.com' }
    end

    def authorize
      redirect_to(edit_team_path)
    end
  end
end
