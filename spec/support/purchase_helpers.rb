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

  def fill_out_subscription_form_with(credit_card_number)
    fill_in 'GitHub username', with: 'cpytel'
    fill_out_credit_card_form_with(credit_card_number)
  end

  def fill_out_credit_card_form_with(credit_card_number)
    credit_card_expires_on = Time.now.advance(years: 1)
    month_selection = credit_card_expires_on.strftime('%-m - %B')
    year_selection = credit_card_expires_on.strftime('%Y')

    fill_in 'Card Number', with: credit_card_number
    select month_selection, from: 'date[month]'
    select year_selection, from: 'date[year]'
    fill_in 'CVC', with: '333'
    click_button 'Submit Payment'
  end

  def expect_submit_button_to_contain(text)
    expect(page).to have_css('#purchase_submit_action input', value: /#{text}/i)
  end
end
