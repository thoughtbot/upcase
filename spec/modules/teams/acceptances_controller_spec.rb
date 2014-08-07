require "rails_helper"

module Teams
  describe AcceptancesController, type: :controller do
    it 'denies access when no users are remaining' do
      invitation = build_stubbed(:invitation)
      invitation.stubs(:has_users_remaining?).returns(false)
      Invitation.stubs(:find).with(invitation.to_param).returns(invitation)

      get :new, invitation_id: invitation.to_param

      should deny_access(flash: 'There are no users remaining for that team.')
    end
  end
end
