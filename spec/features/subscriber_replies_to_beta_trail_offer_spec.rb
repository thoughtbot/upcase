require "rails_helper"

feature "subscriber replies to beta trail offer" do
  scenario "requests access" do
    view_beta_offer "Exciting Beta Trail"

    expect(page).to have_content("Exciting Beta Trail")

    click_on I18n.t("beta.offers.actions.accept")

    expect(page).to have_content(I18n.t("beta.replies.flashes.accepted"))
    expect(page).not_to have_content("Exciting Beta Trail")
  end

  scenario "declines" do
    view_beta_offer "Exciting Beta Trail"

    expect(page).to have_content("Exciting Beta Trail")

    click_on I18n.t("beta.offers.actions.decline")

    expect(page).to have_content(I18n.t("beta.replies.flashes.declined"))
    expect(page).not_to have_content("Exciting Beta Trail")
  end

  def view_beta_offer(name)
    user = create(:subscriber)
    trail = create(:trail)
    create(:status, user: user, completeable: trail, state: Status::COMPLETE)
    create(:beta_offer, name: name)
    visit practice_path(as: user)
  end
end
