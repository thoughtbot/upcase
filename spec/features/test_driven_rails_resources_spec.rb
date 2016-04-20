require "rails_helper"

feature 'Test-Driven Rails Resources' do
  scenario 'View the resources' do
    visit "/upcase/test-driven-rails-resources"

    expect(page).to have_css("a[href*='#{amazon_product_id}']")
  end

  def amazon_product_id
    '0132350882'
  end
end
