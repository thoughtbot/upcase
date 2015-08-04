require "rails_helper"

feature "Visitor signs up for a subscription", js: true do
  include CheckoutHelpers

  scenario "using the new checkout flow" do
    create_plan
    token = "abc123"

    sign_up(token)

    expect_to_see_checkout_success_flash
    expect(FakeStripe.last_token).to eq("abc123")
    expect(User.last).to have_active_subscription
    expect(current_path).to eq(welcome_path)
  end

  scenario "and the charge fails" do
    make_stripe_fake_decline_charge
    create_plan

    sign_up

    expect(User.last).not_to have_active_subscription
    expect(page).to have_content("Your credit card was declined")
    expect(current_path).to eq(page_path("join"))
  end

  def sign_up(token = "fake-token")
    visit "/pages/join"
    click_link "Sign up with GitHub"
    click_button "Pay with credit card"
    page.execute_script("submitToken({ id: '#{token}' })")
  end

  def make_stripe_fake_decline_charge
    FakeStripe.failure = true
  end

  def create_plan
    create(:plan, sku: Plan::PROFESSIONAL_SKU)
  end
end
