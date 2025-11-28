require "rails_helper"

RSpec.feature "Test-Driven Rails Resources" do
  scenario "View the resources" do
    visit "/upcase/test-driven-rails-resources"

    expect(page).to have_css("a[href*='#{amazon_product_id}']")
  end

  def amazon_product_id
    # https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882
    "0132350882"
  end
end
