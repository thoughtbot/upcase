require "rails_helper"

feature "User creates a subscription" do
  background do
    create_plan
    sign_in
  end

  scenario "doesn't create a Stripe subscription with an invalid credit card" do
    subscribe_with_invalid_credit_card

    expect(current_user).not_to have_active_subscription
  end

  scenario "sees that the subscription is per month", js: true do
    visit_plan_checkout_page

    expect_submit_button_to_contain("per month")
  end

  scenario "sees that the subscription is per year", js: true do
    Plan.any_instance.stubs(subscription_interval: "year")
    visit_plan_checkout_page

    expect_submit_button_to_contain("per year")
  end

  scenario "user without github username sees github username input" do
    current_user.github_username = nil
    current_user.save!

    visit_plan_checkout_page

    expect(page).to have_github_input
  end

  scenario "user with address has invoice address fields prepopulated" do
    current_user.update!(
      address1: "742 Evergreen Terrace",
      address2: ".",
      city: "Springfield",
      country: "USA",
      organization: "The Simpsons",
      state: "Oh The Mistery",
      zip_code: "More Mistery"
    )

    visit_plan_checkout_page
    click_on "Need an address on your receipt?"

    expect(find_field("Address 1").value).to eq "742 Evergreen Terrace"
    expect(find_field("Address 2").value).to eq "."
    expect(find_field("City").value).to eq "Springfield"
    expect(find_field("Country").value).to eq "USA"
    expect(find_field("Organization").value).to eq "The Simpsons"
    expect(find_field("State / Province").value).to eq "Oh The Mistery"
    expect(find_field("Zip Code").value).to eq "More Mistery"
  end

  scenario "user with github username doesn't see github username input" do
    current_user.github_username = "cpyteltest"
    current_user.save!

    visit_plan_checkout_page

    expect(page).not_to have_github_input
  end

  scenario "with a valid amount off coupon", js: true do
    create_amount_stripe_coupon("5OFF", "once", 500)

    visit coupon_path("5OFF")
    visit_plan_checkout_page

    expect_submit_button_to_contain("$99 per month")

    expect_submit_button_to_contain discount_text("$94.00", "$99")

    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect(current_path).to be_the_practice_page
    expect_to_see_checkout_success_flash_for(@plan.name)
    expect(FakeStripe.last_coupon_used).to eq "5OFF"
  end

  scenario "with a free month coupon", js: true do
    create_recurring_stripe_coupon("THREEFREE", 3, 9900)

    visit coupon_path("THREEFREE")
    visit_plan_checkout_page

    expect_submit_button_to_contain("$99 per month")
    expect_submit_button_to_contain("$0.00 for 3 months, then $99")

    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect_to_see_checkout_success_flash_for(@plan.name)
    expect(FakeStripe.last_coupon_used).to eq "THREEFREE"
  end

  scenario "with a valid percent off coupon", js: true do
    create_percentage_off_stripe_coupon("50OFF", "once", 50)

    visit coupon_path("50OFF")
    visit_plan_checkout_page

    expect_submit_button_to_contain("$99 per month")

    expect_submit_button_to_contain discount_text("$49.50", "$99")

    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER

    expect_to_see_checkout_success_flash_for(@plan.name)
    expect(current_path).to be_the_practice_page
    expect(Checkout.last.stripe_coupon_id).to eq "50OFF"
    expect(FakeStripe.last_coupon_used).to eq "50OFF"
  end

  scenario "with an invalid coupon", js: true do
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
    new_plan = create(:plan, sku: Plan::PROFESSIONAL_SKU)
    sign_in_as_user_with_subscription
    visit my_account_path

    expect_to_see_the_current_plan(current_user.subscription.plan)

    click_link I18n.t("subscriptions.change_plan")
    within("[data-sku='#{new_plan.sku}']") do
      click_link I18n.t("subscriptions.choose_plan_html")
    end

    expect(current_path).to eq my_account_path
    expect_to_see_the_current_plan(new_plan)
    expect(page).to have_content(I18n.t("subscriptions.flashes.change.success"))
    expect(FakeStripe.customer_plan_id).to eq Plan::PROFESSIONAL_SKU
  end

  scenario "does not see option to update billing if not subscribing" do
    visit my_account_path

    expect(page).not_to have_content("Your Billing Info")
  end

  scenario "does not see call out to subscribe if already subscribed" do
    plan = create(:plan, name: "Upcase")
    create(:video_tutorial, name: "A Cool VideoTutorial")
    sign_in_as_user_with_subscription

    visit products_path

    expect(find(".header-container")).not_to have_content(
      "#{plan.name} Membership"
    )

    find(".video_tutorial > a").click

    expect(page).not_to have_link("Subscribe to #{plan.name}")
  end

  scenario "existing user tries to subscribe with duplicate github", js: true do
    create(:user, github_username: "taken")
    user = create(:user)

    visit new_checkout_path(@plan, as: user)
    fill_in "GitHub username", with: "taken"
    fill_out_subscription_form_with_valid_credit_card

    expect(page).to have_content("has already been taken")
    expect(page).not_to have_content("Your Billing Info")
  end

  scenario "User subscribes with an existing credit card", js: true do
    user = create(:user, :with_github, stripe_customer_id: "test")

    visit new_checkout_path(@plan, as: user)
    pay_using_stripe_with_existing_card

    expect_to_see_checkout_success_flash_for(@plan.name)
  end

  def visit_plan_checkout_page
    visit new_checkout_path(@plan)
  end

  def create_plan
    @plan = create(:plan)
  end

  def subscribe_with_valid_credit_card
    visit_plan_checkout_page
    fill_out_subscription_form_with VALID_SANDBOX_CREDIT_CARD_NUMBER
  end

  def subscribe_with_invalid_credit_card
    visit_plan_checkout_page
    FakeStripe.failure = true
    fill_out_subscription_form_with "bad cc number"
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
