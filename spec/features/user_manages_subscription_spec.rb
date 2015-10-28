require "rails_helper"

feature "User creates a subscription" do
  background do
    create_plan
    sign_in
  end

  scenario "doesn't create a Stripe subscription with an invalid credit card" do
    subscribe_with_invalid_credit_card

    expect(page).to have_credit_card_error
    expect(current_user).not_to have_active_subscription
  end

  scenario "sees that the subscription is per month" do
    visit_plan_checkout_page

    expect_submit_button_to_contain("per month")
  end

  scenario "sees that the subscription is per year" do
    allow_any_instance_of(Plan).to receive(:subscription_interval).
      and_return("year")
    visit_plan_checkout_page

    expect_submit_button_to_contain("per year")
  end

  scenario "user with github username doesn't see github username input" do
    current_user.github_username = "cpyteltest"
    current_user.save!

    visit_plan_checkout_page

    expect(page).not_to have_github_input
  end

  scenario "with a valid amount off coupon" do
    create(:coupon, code: "5OFF", duration: "once", amount_off: 500)

    visit coupon_path("5OFF")
    visit_plan_checkout_page

    expect_submit_button_to_contain("$99 per month")

    expect_submit_button_to_contain discount_text("$94.00", "$99")

    fill_out_credit_card_form_with_valid_credit_card

    expect(current_path).to be_the_welcome_page
    expect_to_see_checkout_success_flash
    expect(FakeStripe.last_coupon_used).to eq "5OFF"
  end

  scenario "with a free month coupon" do
    create(
      :coupon,
      code: "THREEFREE",
      duration: "repeating",
      duration_in_months: 3,
      amount_off: 9900,
    )

    visit coupon_path("THREEFREE")
    visit_plan_checkout_page

    expect_submit_button_to_contain("$99 per month")
    expect_submit_button_to_contain("$0.00 for 3 months, then $99")

    fill_out_credit_card_form_with_valid_credit_card

    expect_to_see_checkout_success_flash
    expect(FakeStripe.last_coupon_used).to eq "THREEFREE"
  end

  scenario "with a valid percent off coupon" do
    create(
      :coupon,
      code: "50OFF",
      duration: "once",
      amount_off: nil,
      percent_off: 50,
    )

    visit coupon_path("50OFF")
    visit_plan_checkout_page

    expect_submit_button_to_contain("$99 per month")

    expect_submit_button_to_contain discount_text("$49.50", "$99")

    fill_out_credit_card_form_with_valid_credit_card

    expect_to_see_checkout_success_flash
    expect(current_path).to be_the_welcome_page
    expect(Checkout.last.stripe_coupon_id).to eq "50OFF"
    expect(FakeStripe.last_coupon_used).to eq "50OFF"
  end

  scenario "with an invalid coupon" do
    visit coupon_path("50OFF")
    expect(page).to have_content("The coupon code you supplied is not valid.")

    visit_plan_checkout_page

    expect_submit_button_to_contain("$99 per month")
  end

  scenario "sees option to update billing for subscribers" do
    sign_in_as_user_with_subscription
    visit my_account_path

    expect(page).to have_content("Your Billing Info")
  end

  scenario "changes subscription plan" do
    new_plan = create(:plan, :featured)
    sign_in_as_user_with_subscription
    visit my_account_path

    expect_to_see_the_current_plan(current_user.subscription.plan)

    visit edit_subscription_path
    within("[data-sku='#{new_plan.sku}']") do
      click_link I18n.t("subscriptions.choose_plan")
    end

    expect(current_path).to eq my_account_path
    expect_to_see_the_current_plan(new_plan)
    expect(page).to have_content(I18n.t("subscriptions.flashes.change.success"))
    expect(FakeStripe.customer_plan_id).to eq new_plan.sku
  end

  scenario "does not see option to update billing if not subscribing" do
    visit my_account_path

    expect(page).not_to have_content("Your Billing Info")
  end

  def visit_plan_checkout_page
    visit new_checkout_path(@plan)
  end

  def create_plan
    @plan = create(:plan)
  end

  def subscribe_with_valid_credit_card
    visit_plan_checkout_page
    fill_out_credit_card_form_with_valid_credit_card
  end

  def subscribe_with_invalid_credit_card
    visit_plan_checkout_page
    fill_out_credit_card_form_with_invalid_credit_card
  end

  def discount_text(new, original)
    I18n.t(
      "subscriptions.discount.once",
      final_price: new,
      full_price: original,
    )
  end

  def expect_to_see_the_current_plan(plan)
    expect(page).to have_css(
      ".subscription p strong",
      text: plan.name
    )
  end

  def have_github_input
    have_content("GitHub username") &&
      have_css("input#checkout_github_username")
  end
end
