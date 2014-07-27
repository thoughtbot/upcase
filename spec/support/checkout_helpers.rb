VALID_SANDBOX_CREDIT_CARD_NUMBER = '4111111111111111'

module CheckoutHelpers
  def fill_in_name_and_email
    fill_in 'Name', with: 'Ben'
    fill_in 'Email', with: 'ben@thoughtbot.com'
  end

  def fill_out_subscription_form_with_valid_credit_card
    fill_out_credit_card_form_with(VALID_SANDBOX_CREDIT_CARD_NUMBER)
  end

  def fill_out_subscription_form_with(credit_card_number)
    fill_in 'GitHub username', with: 'cpytel'
    fill_out_credit_card_form_with(credit_card_number)
  end

  def fill_out_credit_card_form_with_valid_credit_card
    fill_out_credit_card_form_with(VALID_SANDBOX_CREDIT_CARD_NUMBER)
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

  def fill_out_account_creation_form(user_attributes={})
    user = build(:user)
    fill_in 'Name', with: user_attributes[:name] || user.name
    fill_in 'Email', with: user_attributes[:email] || user.email
    fill_in 'Password', with: user.password
    fill_in 'GitHub username', with: 'cpytel'
  end

  def expect_submit_button_to_contain(text)
    expect(page.find("#checkout_submit_action input").value).to include text
  end

  def expect_to_see_checkout_success_flash_for(plan_name)
    expect(page).to have_content(I18n.t("checkout.flashes.success", name: plan_name))
  end
end
