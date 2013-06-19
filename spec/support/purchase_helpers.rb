module PurchaseHelpers
  def expect_to_have_purchased(product)
    expect(page).to have_content "Thank you for purchasing #{product.name}"
    expect(FakeMailchimp.lists[product.sku]).to include 'ben@thoughtbot.com'
  end

  def click_purchase_link
    click_link 'Purchase for Yourself'
  end

  def fill_in_name_and_email
    fill_in 'Name', with: 'Ben'
    fill_in 'Email', with: 'ben@thoughtbot.com'
  end
end
