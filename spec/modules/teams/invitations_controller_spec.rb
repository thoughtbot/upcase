require 'rails_helper'

module Teams
  describe InvitationsController, type: :controller do
    it_behaves_like 'must be team member' do
      def perform_request
        invitation = stub('invitation', deliver: true)
        Invitation.stubs(:new).returns(invitation)

        post :create, teams_invitation: { email: 'somebody@example.com' }
      end

      def authorize
        redirect_to(edit_teams_team_path)
      end
    end
  end
end
