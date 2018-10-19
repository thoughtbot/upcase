require "rails_helper"

feature "User accesses GitHub repository" do
  scenario "gets added as a collaborator" do
    repository = create(:repository)
    sign_in

    visit practice_path
    click_on "Upcase source code on GitHub"
    click_on repository.name
    click_link I18n.t("repository.view_repository")

    expect(page).to have_content("We're adding you to the GitHub repository")
  end
end
