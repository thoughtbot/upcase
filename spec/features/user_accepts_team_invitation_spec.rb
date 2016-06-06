require "rails_helper"

feature "Accept team invitations" do
  context "when user does not have an account" do
    scenario "and signs up with username and password" do
      owner_email = "owner@somedomain.com"
      invited_email = "invited-member@example.com"
      team_owner_name = "Pink Panther"
      visit_team_plan_checkout_page
      fill_out_account_creation_form name: team_owner_name, email: owner_email
      fill_out_credit_card_form_with_valid_credit_card

      fill_in "Email", with: invited_email
      click_on "Send"

      in_new_session do
        open_invitation_email(to: invited_email)

        fill_in "Name", with: "Team Member"
        fill_in "GitHub username", with: "tmember"
        fill_in "Password", with: "secret"
        click_on "Create an account"

        my_account_link.click

        expect(page).to have_field("Email", with: invited_email)
        expect(page).to have_content("Team: Somedomain")
        expect(page).to have_content(
          I18n.t("teams.team.team_owner_html", owner_email: team_owner_name),
        )
      end
    end

    scenario "fills in the form incorrectly, then signs up" do
      invited_email = "invited-member@example.com"
      create_account(owner_email: "owner@somedomain.com")

      fill_in "Email", with: invited_email
      click_on "Send"

      in_new_session do
        open_invitation_email(to: invited_email)

        fill_in "Name", with: "Team Member"
        fill_in "GitHub username", with: "tmember"
        click_on "Create an account"

        expect(page).to have_content("can't be blank")

        fill_in "Password", with: "secret"
        click_on "Create an account"

        expect(page).to have_content(I18n.t("shared.header.trails"))
      end
    end

    scenario "user can use an invitation sent to their work email" do
      work_email = "work@example.com"
      user = create(:user, :with_github, email: "home@example.com")
      create_account(owner_email: "owner@somedomain.com")

      fill_in "Email", with: work_email
      click_on "Send"

      in_new_session do
        sign_in_as user
        open_invitation_email(to: work_email)

        fill_in "Password", with: "password"
        click_on "Join team"

        expect(page).to have_content("You've been added to the team. Enjoy!")

        my_account_link.click
        expect(page).to have_field("Email", with: user.email)
        expect(page).to have_content("Team: Somedomain")
      end
    end
  end

  context "when user does have an account" do
    scenario "user with no GitHub and no subscription already exists" do
      user = create(
        :user,
        password: "password",
        email: "invited-member@example.com",
      )
      create_account(owner_email: "owner@somedomain.com")

      fill_in "Email", with: user.email
      click_on "Send"

      in_new_session do
        open_invitation_email(to: user.email)

        fill_in "GitHub username", with: "tmember"
        fill_in "Password", with: user.password
        click_on "Join team"

        expect(page).to have_content("You've been added to the team. Enjoy!")

        my_account_link.click
        expect(page).to have_field("Email", with: user.email)
        expect(page).to have_content("Team: Somedomain")
      end
    end

    scenario "user with GitHub and no subscription already exists" do
      user = create(:user, :with_github, email: "invited-member@example.com")
      create_account(owner_email: "owner@somedomain.com")

      fill_in "Email", with: user.email
      click_on "Send"

      in_new_session do
        open_invitation_email(to: user.email)

        fill_in "Password", with: "password"
        click_on "Join team"

        expect(page).to have_content("You've been added to the team. Enjoy!")

        my_account_link.click
        expect(page).to have_field("Email", with: user.email)
        expect(page).to have_content("Team: Somedomain")
      end
    end
  end

  def in_new_session
    using_session :team_member do
      yield
    end
  end

  def open_invitation_email(to:)
    open_email(to)
    click_first_link_in_email
  end

  def create_account(owner_email:)
    visit_team_plan_checkout_page
    fill_out_account_creation_form email: owner_email
    fill_out_credit_card_form_with_valid_credit_card
  end
end
