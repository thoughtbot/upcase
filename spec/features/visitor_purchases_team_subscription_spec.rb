require "rails_helper"

feature 'Visitor can purchase a subscription for their team' do
  scenario 'successful purchase' do
    create_team_plan
    navigate_to_team_sign_up

    fill_out_account_creation_form email: 'user@fabtabulous.com'
    fill_out_credit_card_form_with_valid_credit_card

    expect_to_see_checkout_success_flash

    my_account_link.click

    expect_to_see_team_name 'Fabtabulous'
  end

  def create_team_plan
    create(:plan, :team, :featured)
  end

  def navigate_to_team_sign_up
    visit root_path
    click_link I18n.t("shared.header.teams")
    click_link I18n.t("subscriptions.join_cta")
  end

  def expect_to_see_team_name(team_name)
    expect(page).to have_content(team_name)
  end
end
