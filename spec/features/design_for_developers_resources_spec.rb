require "rails_helper"

feature 'Design For Developers Resources' do
  scenario 'View the resources' do
    visit "/upcase/design-for-developers-resources"

    expect(page).to have_css("a[href*='#{amazon_product_id}']")
  end

  def amazon_product_id
    # https://www.amazon.com/Visual-Display-Quantitative-Information-2nd/dp/0961392142
    '0961392142'
  end
end
