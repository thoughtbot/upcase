require "rails_helper"

feature "Accept team invitations" do
  scenario "and signs up" do
    owner_email = "owner@somedomain.com"
    visit_team_plan_checkout_page
    fill_out_account_creation_form name: "Pink Panther", email: owner_email
    fill_out_credit_card_form_with_valid_credit_card

    fill_in "Email", with: "invited-member@example.com"
    click_on "Send"

    using_session :team_member do
      open_email "invited-member@example.com"
      click_first_link_in_email

      fill_in "Name", with: "Team Member"
      fill_in "GitHub username", with: "tmember"
      fill_in "Password", with: "secret"
      click_on "Create an account"

      my_account_link.click

      expect(page).to have_field("Email", with: "invited-member@example.com")
      expect(page).to have_content("Team: Somedomain")
      expect(page).to have_content <<-EOS.squish
        Your team owner, Pink Panther, can make changes to your subscription.
      EOS
    end
  end

  scenario "fills in the form incorrectly, then signs up" do
    visit_team_plan_checkout_page
    fill_out_account_creation_form email: "owner@somedomain.com"
    fill_out_credit_card_form_with_valid_credit_card

    fill_in "Email", with: "invited-member@example.com"
    click_on "Send"

    using_session :team_member do
      open_email "invited-member@example.com"
      click_first_link_in_email

      fill_in "Name", with: "Team Member"
      fill_in "GitHub username", with: "tmember"
      click_on "Create an account"

      expect(page).to have_content("can't be blank")

      fill_in "Password", with: "secret"
      click_on "Create an account"

      expect(page).to have_content(I18n.t("shared.header.trails"))
    end
  end

  scenario "user with no github and no subscripion already exists" do
    create(:user, password: "password", email: "invited-member@example.com")

    visit_team_plan_checkout_page
    fill_out_account_creation_form email: "owner@somedomain.com"
    fill_out_credit_card_form_with_valid_credit_card

    fill_in "Email", with: "invited-member@example.com"
    click_on "Send"

    using_session :team_member do
      open_email "invited-member@example.com"
      click_first_link_in_email

      fill_in "GitHub username", with: "tmember"
      fill_in "Password", with: "password"
      click_on "Join team"

      expect(page).to have_content("You've been added to the team. Enjoy!")

      my_account_link.click
      expect(page).to have_field("Email", with: "invited-member@example.com")
      expect(page).to have_content("Team: Somedomain")
    end
  end

  scenario "user with github and no subscripion already exists" do
    create(:user, :with_github, email: "invited-member@example.com")

    visit_team_plan_checkout_page
    fill_out_account_creation_form email: "owner@somedomain.com"
    fill_out_credit_card_form_with_valid_credit_card

    fill_in "Email", with: "invited-member@example.com"
    click_on "Send"

    using_session :team_member do
      open_email "invited-member@example.com"
      click_first_link_in_email

      fill_in "Password", with: "password"
      click_on "Join team"

      expect(page).to have_content("You've been added to the team. Enjoy!")

      my_account_link.click
      expect(page).to have_field("Email", with: "invited-member@example.com")
      expect(page).to have_content("Team: Somedomain")
    end
  end

  scenario "user is authenticated with another email address" do
    user = create(:user, :with_github, email: "member@example.com")

    visit_team_plan_checkout_page
    fill_out_account_creation_form email: "owner@somedomain.com"
    fill_out_credit_card_form_with_valid_credit_card

    fill_in "Email", with: "invited-member@example.com"
    click_on "Send"

    using_session :team_member do
      sign_in_as user
      open_email "invited-member@example.com"
      click_first_link_in_email

      fill_in "Password", with: "password"
      click_on "Join team"

      expect(page).to have_content("You've been added to the team. Enjoy!")

      my_account_link.click
      expect(page).to have_field("Email", with: "member@example.com")
      expect(page).to have_content("Team: Somedomain")
    end
  end
end
