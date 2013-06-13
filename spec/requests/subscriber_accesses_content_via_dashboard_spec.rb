require 'spec_helper'

feature 'Subscriber accesses content' do
  scenario 'begins an online workshop' do
    online_section = create(:online_section)

    sign_in_as_user_with_subscription
    click_online_workshop_detail_link

    expect(page).to have_content I18n.t('workshops.show.free_to_subscribers')

    click_link I18n.t('workshops.show.register')

    expect(page).not_to have_content 'GitHub'
    expect(page).not_to have_content I18n.t('purchase.comments')
    click_button 'Get Access'

    expect(page).to have_content I18n.t('subscriber_purchase.flashes.success')
    expect(page).not_to have_content('Receipt')
  end

  scenario 'gets access to a book product' do
    book_product = create(:github_book_product)
    sign_in_as_user_with_subscription
    stub_github_fulfillment_job

    click_ebook_detail_link
    click_link I18n.t('products.show.purchase_for_subscribed_user', product_type: book_product.product_type)
    click_button 'Get Access'

    expect(GithubFulfillmentJob).to have_received(:enqueue).
      with(
        book_product.github_team,
        [@current_user.github_username],
        Purchase.last.id
      )
  end

  scenario 'gets access to a screencast' do
    video = create(:video_product)
    sign_in_as_user_with_subscription
    click_screencast_detail_link(video)
    click_link 'Get this video'
    click_button 'Get Access'

    expect(page).to have_content('Watch or Download Video')
  end

  scenario 'accesses Prime Bytes' do
    byte = create(:byte)

    sign_in_as_user_with_subscription
    click_link 'View all Prime Bytes'

    expect(page).to have_content(byte.title)
    expect(current_path).to eq bytes_path
  end

  scenario "can't register for overlapping workshops" do
    online_section = create(:online_section)
    overlapping_section = create(
      :online_section,
      starts_on: online_section.starts_on,
      ends_on: online_section.ends_on
    )

    sign_in_as_user_with_subscription
    click_online_workshop_detail_link
    click_link I18n.t('workshops.show.register')
    click_button 'Get Access'

    visit products_path

    click_online_workshop_detail_link
    expect(page).to_not have_content I18n.t('workshops.show.register')
  end

  scenario 'gets access to an in-person workshop' do
    in_person_section = create(:in_person_section)

    sign_in_as_user_with_subscription
    click_in_person_workshop_detail_link

    expect(page).to have_content I18n.t('workshops.show.free_to_subscribers')

    click_link I18n.t('workshops.show.register')

    expect(page).not_to have_content 'GitHub'
    expect(page).to have_content I18n.t('purchase.comments')
    fill_in 'subscriber_purchase_comments', with: 'Vegetarian'
    click_button 'Get Access'

    expect(page).to have_content I18n.t('subscriber_purchase.flashes.success')
    expect(page).not_to have_content 'Receipt'
  end

  def stub_github_fulfillment_job
    GithubFulfillmentJob.stubs(:enqueue)
  end

  def click_online_workshop_detail_link
    within('.workshop-online') do
      click_link 'Learn More'
    end
  end

  def click_in_person_workshop_detail_link
    within('.workshop-inperson') do
      click_link 'Learn More'
    end
  end

  def click_screencast_detail_link(screencast)
    within('.screencast') do
      click_link screencast.name
    end
  end

  def click_ebook_detail_link
    within('section.books') do
      click_link 'Learn More'
    end
  end
end
