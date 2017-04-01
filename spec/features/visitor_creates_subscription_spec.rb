require "rails_helper"

feature "Visitor signs up for a subscription" do
  background do
    create_plan
  end

  scenario "visitor signs up by navigating from landing page", js: true do
    create(:trail, :published)

    visit root_path(campaign_params)
    click_link I18n.t("marketing.show.start_learning")
    show_email_and_username_form
    fill_out_account_creation_form
    fill_out_credit_card_form_with_valid_credit_card

    expect(current_path).to be_the_welcome_page
    expect_to_see_checkout_success_flash
    expect_analytics_to_have_received_subscribed_event
  end

  scenario "and creates email/password user", js: true do
    visit new_checkout_path(@plan)
    expect(page).to have_text "Sign up with GitHub"
    expect(page).to have_text "Already have an account? Sign in"

    show_email_and_username_form

    expect_to_be_on_checkout_page
    expect_to_see_required :name
    expect_to_see_required :password
    expect_to_see_required :email
    expect_to_see_required :github_username
    expect(page).not_to have_text "Sign up with GitHub"
    expect(page).not_to have_text "Already have an account? Sign in"

    fill_in_name_and_credit_card

    expect_to_see_password_error
    expect_to_see_email_error

    fill_out_account_creation_form
    fill_out_credit_card_form_with_valid_credit_card

    expect(current_path).to be_the_welcome_page
    expect_to_see_checkout_success_flash
  end

  scenario "without specifying a GitHub username", js: true do
    begin_to_subscribe_with_email_and_password

    user = build(:user)
    fill_in "Name", with: user.name
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Submit Payment"

    expect(page).to have_css("li.error input#checkout_github_username")
  end

  scenario "with an email address that is already taken", js: true do
    existing_user = create(:user)

    begin_to_subscribe_with_email_and_password
    fill_out_account_creation_form(
      name: existing_user.name,
      email: existing_user.email,
    )
    fill_out_credit_card_form_with_valid_credit_card

    expect_to_see_email_error("has already been taken")
  end

  scenario "visitor attempts to subscribe and creates github user" do
    visit new_checkout_path(@plan)

    click_link "Sign up with GitHub"

    expect_to_be_on_checkout_page

    expect(page).to have_no_field "Password"

    fill_out_credit_card_form_with_valid_credit_card

    expect(current_path).to be_the_welcome_page
    expect_to_see_checkout_success_flash
  end

  scenario "with an existing github username", js: true do
    existing_user = create(:user, :with_github_auth)

    begin_to_subscribe_with_email_and_password
    fill_out_account_creation_form_as existing_user
    fill_out_credit_card_form_with_valid_credit_card

    expect(current_path).to be_the_checkouts_page
    expect_error_on_github_username_field
  end

  scenario "with invalid credit card and corrects mistakes", js: true do
    begin_to_subscribe_with_email_and_password
    fill_out_account_creation_form
    fill_out_credit_card_form_with_invalid_credit_card

    expect(page).to have_credit_card_error

    fill_out_credit_card_form_with_valid_credit_card

    expect_to_see_checkout_success_flash
  end

  scenario "analytics is notified when a user auths on the checkout page" do
    visit new_checkout_path(@plan)
    click_link I18n.t("checkout.sign_up_with_github")

    expect_to_be_on_checkout_page

    expect(analytics).to have_tracked("Authenticated on checkout")
  end

  def expect_error_on_github_username_field
    expect(github_username_field[:class]).to include("error")
  end

  def expect_to_be_on_checkout_page
    expect(current_path).to eq new_checkout_path(@plan)
  end

  def expect_to_see_required(field)
    expect(page).to have_css("#checkout_#{field}_input abbr[title=required]")
  end

  def expect_to_see_email_error(text = "can't be blank")
    expect(page).to have_css(
      "#checkout_email_input.error p.inline-errors",
      text: text
    )
  end

  def expect_to_see_password_error
    expect(page).to have_css(
      "#checkout_password_input.error p.inline-errors",
      text: "can't be blank"
    )
  end

  def expect_analytics_to_have_received_subscribed_event
    expect(analytics).to(
      have_tracked(Analytics::SUBSCRIBED_EVENT_NAME).
        with_properties(
          context: {
            campaign: campaign_params,
          },
          plan: @plan.sku,
          revenue: @plan.price_in_dollars,
        ),
    )
  end

  def create_plan
    @plan = create(:plan, :featured)
  end

  def begin_to_subscribe_with_email_and_password
    visit new_checkout_path(@plan)
    show_email_and_username_form
  end

  def show_email_and_username_form
    click_on I18n.t(
      "checkouts.user_information_fields.sign_up_with_username_and_password",
    )
  end

  def fill_in_name_and_credit_card
    fill_in "Name", with: build(:user).name
    fill_out_credit_card_form_with_valid_credit_card
  end

  def github_username_field
    find("#checkout_github_username_input")
  end

  def campaign_params
    {
      utm_campaign: "my_utm_campaign",
      utm_medium: "my_utm_medium",
      utm_source: "my_utm_source",
    }
  end
end
