require 'spec_helper'

feature 'Subscriber accesses content' do
  scenario 'accesses a workshop product detail page' do
    workshop = create(:online_workshop)
    sign_in_as_user_with_subscription
    within('.workshop-online') do
      click_link 'Info'
    end

    expect(current_path).to eq workshop_path(workshop)
  end

  scenario 'gets access to a book product' do
    book_product = create(:github_book_product)
    sign_in_as_user_with_subscription
    stub_github_fulfillment_job

    click_link book_product.name
    click_link I18n.t('products.show.purchase_for_subscribed_user', product_type: book_product.product_type)
    click_button 'Get Access'

    expect(GithubFulfillmentJob).to have_received(:enqueue).
      with(
        book_product.github_team,
        [@current_user.github_username],
        Purchase.last.id
      )
  end

  scenario 'gets access to an online workshop' do
    online_section = create(:online_section)

    sign_in_as_user_with_subscription
    click_link online_section.workshop.name

    expect(page).to have_content I18n.t('workshops.show.free_to_subscribers')

    click_link I18n.t('workshops.show.register')

    expect(page).not_to have_content 'GitHub'
    expect(page).not_to have_content I18n.t('purchase.comments')
    click_button 'Get Access'

    expect(page).to have_content I18n.t('subscriber_purchase.flashes.success')
    expect(page).not_to have_content('Receipt')
    user_should_have_purchased(online_section)
  end

  scenario "can't register for overlapping workshops" do
    online_section = create(:online_section)
    overlapping_section = create(
      :section,
      starts_on: online_section.starts_on,
      ends_on: online_section.ends_on
    )

    sign_in_as_user_with_subscription

    click_link online_section.workshop.name
    click_link I18n.t('workshops.show.register')
    click_button 'Get Access'

    visit products_path

    click_link overlapping_section.workshop.name
    click_link I18n.t('workshops.show.register')

    expect(page).to have_content 'Only one workshop at a time'
    expect(page).to have_css 'section #notify-me'
  end

  scenario 'gets access to an in-person workshop' do
    in_person_section = create(:in_person_section)

    sign_in_as_user_with_subscription
    click_link in_person_section.workshop.name

    expect(page).to have_content I18n.t('workshops.show.free_to_subscribers')

    click_link I18n.t('workshops.show.register')

    expect(page).not_to have_content 'GitHub'
    expect(page).to have_content I18n.t('purchase.comments')
    fill_in 'subscriber_purchase_comments', with: 'Vegetarian'
    click_button 'Get Access'

    expect(page).to have_content I18n.t('subscriber_purchase.flashes.success')
    expect(page).not_to have_content 'Receipt'
    user_should_have_purchased(in_person_section)
  end

  def create_all_product_types
    create(:video_product)
    create(:book_product)
    create(:online_workshop)
    create(:in_person_workshop)
    create(:subscribeable_product)
  end

  def stub_github_fulfillment_job
    GithubFulfillmentJob.stubs(:enqueue)
  end

  def user_should_have_purchased(purchaseable)
    @current_user.paid_purchases.last.purchaseable.should == purchaseable
  end
end
