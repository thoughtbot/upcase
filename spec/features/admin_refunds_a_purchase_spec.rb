require 'spec_helper'

feature 'Admin refunds a purchase' do
  scenario 'and the purchase is refunded' do
    user = create(:admin)
    create(:paid_purchase)
    visit admin_path(as: user)

    refund_purchase

    expect(page).to have_success_message
  end

  def refund_purchase
    click_on 'Purchases'
    refund_button.click
  end

  def refund_button
    find('[title="Refund Purchase"] a')
  end

  def have_success_message
    have_css '.alert', text: 'Purchase refunded'
  end
end
