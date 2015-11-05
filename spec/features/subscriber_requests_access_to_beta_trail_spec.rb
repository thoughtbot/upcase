require "rails_helper"

feature "subscriber requests access to beta trail" do
  scenario "gets added to database" do
    user = create(:subscriber)
    trail = create(:trail)
    create(:status, user: user, completeable: trail, state: Status::COMPLETE)
    create(:beta_offer, name: "Exciting Beta Trail")

    visit practice_path(as: user)

    expect(page).to have_content("Exciting Beta Trail")

    click_on "Request Access"

    expect(page).not_to have_content("Exciting Beta Trail")
  end
end
