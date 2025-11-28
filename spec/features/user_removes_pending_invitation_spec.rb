require "rails_helper"

RSpec.feature "Remove pending invitations" do
  include ActionView::RecordIdentifier

  scenario "an owner removes a team member" do
    owner = create(:user, :with_attached_team)
    invitation_to_remove = create(:invitation, team: owner.team)

    visit my_account_path(as: owner)
    click_link "Manage Users"

    expect(page).to have_css("ul.invitations li", count: 1)

    click_link dom_id(invitation_to_remove, "remove")

    expect(page).to have_no_css("ul.invitations")
    expect(page).to have_content("invitation has been removed")
  end
end
