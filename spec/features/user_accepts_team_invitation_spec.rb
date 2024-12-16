require "rails_helper"

feature "Accept team invitations" do
  context "when user is signed in" do
    it "accepts the invitation immediately" do
      create_team_account
      user = create(:user)

      fill_in "Email", with: user.email
      click_on "Send"

      in_new_session do
        sign_in_as(user)
        open_invitation_email(to: user.email)

        expect(page).to have_content("You've been added to the team. Enjoy!")

        my_account_link.click
        expect(page).to have_team_member(user: user)
      end
    end

    context "when the invitation email does not match the signed-in user" do
      it "accepts the invitation because it's probably their work email" do
        work_email = "work@example.com"
        user = create(:user, email: "home@example.com")
        create_team_account(owner_email: "owner@somedomain.com")

        fill_in "Email", with: work_email
        click_on "Send"

        in_new_session do
          sign_in_as(user)
          open_invitation_email(to: work_email)

          expect(page).to have_content("You've been added to the team. Enjoy!")

          my_account_link.click
          expect(page).to have_team_member(user: user)
        end
      end
    end
  end

  context "when user who signed up via GitHub is signed out" do
    scenario "and user's email matches invited email" do
      invited_email = "invited-member@example.com"
      user = create(:user, :with_github_auth, email: invited_email)
      create_team_account(owner_email: "owner@somedomain.com")

      fill_in "Email", with: user.email
      click_on "Send"

      in_new_session do
        open_invitation_email(to: user.email)
        click_on I18n.t("authenticating.github_signin")

        my_account_link.click

        expect(page).to have_team_member(user: user)
      end
    end

    scenario "and user's email does NOT match invited email" do
      invited_email = "invited-member@example.com"
      user_github_email = "my-github-email@example.com"
      user = create(:user, :with_github_auth, email: user_github_email)
      create_team_account(owner_email: "owner@somedomain.com")

      fill_in "Email", with: invited_email
      click_on "Send"

      in_new_session do
        open_invitation_email(to: invited_email)
        click_on I18n.t("authenticating.github_signin")

        my_account_link.click

        expect(page).to have_team_member(user: user)
      end
    end
  end

  context "when user does not have an account" do
    scenario "and signs up with GitHub" do
      owner_email = "owner@somedomain.com"
      invited_email = "invited-member@example.com"
      owner_name = "Pink Panther"
      create_team_account(owner_name: owner_name, owner_email: owner_email)

      fill_in "Email", with: invited_email
      click_on "Send"

      in_new_session do
        open_invitation_email(to: invited_email)
        click_on I18n.t("authenticating.github_signin")
        github_email = OmniAuth.config.mock_auth[:github].info.email

        my_account_link.click

        expect(page).to have_field("Email", with: github_email)
        expect(page).to have_content("Your Team")
        expect(page).to have_content(
          I18n.t("teams.team.team_owner_html", owner_email: owner_name)
        )
      end
    end
  end

  context "when invitation is already accepted" do
    it "shows an error" do
      invited_user = create(:user)
      taken_user = create(:user)
      invitation = create(:invitation, email: invited_user.email)
      invitation.accept(taken_user)

      in_new_session do
        sign_in_as(invited_user)
        visit new_invitation_acceptance_path(invitation)

        expect(page).to have_content(I18n.t("acceptances.new.invitation_taken"))
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

  def create_team_account(
    owner_name: "Cool Person",
    owner_email: "owner@somedomain.com"
  )
    owner = create(
      :user, :with_attached_team, email: owner_email, name: owner_name
    )
    sign_in_as(owner)
    visit edit_team_path(owner.team)
  end

  def have_team_member(user:)
    have_field("Email", with: user.email).and(
      have_content("Your Team")
    )
  end
end
