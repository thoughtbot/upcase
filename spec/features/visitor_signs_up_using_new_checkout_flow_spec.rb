require "rails_helper"

feature "Visitor signs up for a subscription", js: true do
  include CheckoutHelpers
  include VanityHelpers

  before do
    stub_ab_test_result(:checkout_flow, :new)
  end

  scenario "using the new checkout flow" do
    create_plan
    token = "abc123"

    sign_up(token)

    expect_to_see_checkout_success_flash
    expect(FakeStripe.last_token).to eq("abc123")
    expect(User.last).to have_active_subscription
    expect(current_path).to eq(welcome_path)
    expect(vanity_signup_count).to eq 1
  end

  scenario "and the charge fails" do
    make_stripe_fake_decline_charge
    create_plan

    sign_up

    expect(User.last).not_to have_active_subscription
    expect(page).to have_content("Your credit card was declined")
    expect(current_path).to eq(new_payment_path)
  end

  def sign_up(token = "fake-token")
    visit root_path
    click_link "Auth with GitHub to get started"
    click_link I18n.t("payments.new.pay-button-cta")
    page.execute_script("submitToken({ id: '#{token}' })")
  end

  def make_stripe_fake_decline_charge
    FakeStripe.failure = true
  end

  def create_plan
    create(:plan, sku: Plan::PROFESSIONAL_SKU)
  end
end
