require 'spec_helper'

feature 'Subscriber accesses content' do
  include Gravatarify::Helper

  scenario 'access mentor details' do
    sign_in_as_user_with_subscription
    mentor = @current_user.mentor
    mentor_image = gravatar_url(mentor.email)

    expect(page).to have_content('Your Mentor')
    expect(page).to have_xpath("//img[contains(@src, \"#{mentor_image}\")]")
    expect(page).to have_xpath("//a[contains(@href, \"mailto:#{mentor.email}\")]")
  end

  scenario 'begins an online workshop' do
    online_section = create(:online_section)

    sign_in_as_user_with_subscription
    click_online_workshop_detail_link

    expect(page).to have_content I18n.t('workshops.show.free_to_subscribers')

    click_link I18n.t('workshops.show.register_free')

    expect(page).not_to have_content 'GitHub'
    expect(page).not_to have_content I18n.t('purchase.comments')
    click_button 'Get Access'

    expect(page).to have_content I18n.t('subscriber_purchase.flashes.success')
    expect(page).not_to have_content('Receipt')

    expect_dashboard_to_show_workshop_active(online_section.workshop)
  end

  scenario 'subscriber without access to workshops attempts to begin an online workshop' do
    online_section = create(:online_section)
    create_mentors

    sign_in_as_user_with_downgraded_subscription
    click_online_workshop_detail_link

    expect(page).not_to have_content I18n.t('workshops.show.free_to_subscribers')
    expect(page).to have_content I18n.t('workshops.show.upgrade')

    click_link I18n.t('workshops.show.upgrade')

    expect(current_path).to eq edit_subscription_path
  end

  scenario 'subscriber without access to workshops attempts to begin an in-person workshop' do
    in_person_section = create(:in_person_section)
    create_mentors

    sign_in_as_user_with_downgraded_subscription
    click_in_person_workshop_detail_link

    expect(page).not_to have_content I18n.t('workshops.show.free_to_subscribers')
    expect(page).to have_content I18n.t('workshops.show.upgrade')

    click_link I18n.t('workshops.show.upgrade')

    expect(current_path).to eq edit_subscription_path
  end
 

  scenario 'gets access to a book product' do
    book_product = create(:github_book_product)
    sign_in_as_user_with_subscription
    stub_github_fulfillment_job

    click_ebook_detail_link(book_product)
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

    expect(page).to have_content('Watch or download video')
  end

  scenario "registering for overlapping workshops" do
    online_section = create(:online_section)
    overlapping_section = create(
      :online_section,
      starts_on: online_section.starts_on,
      ends_on: online_section.ends_on
    )

    sign_in_as_user_with_subscription
    click_link online_section.name
    click_link I18n.t('workshops.show.register_free')
    click_button 'Get Access'

    visit products_path

    click_link overlapping_section.name
    click_link I18n.t('workshops.show.register_free')
    expect(page).to have_content(I18n.t('workshops.overlapping'))
    click_button 'Get Access'
  end

  scenario 'gets access to an in-person workshop' do
    in_person_section = create(:in_person_section)

    sign_in_as_user_with_subscription
    click_in_person_workshop_detail_link

    click_link I18n.t('workshops.show.register_free_inperson')

    expect(page).not_to have_content 'GitHub'
    expect(page).to have_content I18n.t('purchase.comments')
    fill_in 'subscriber_purchase_comments', with: 'Vegetarian'
    click_button 'Get Access'

    expect(page).to have_content I18n.t('subscriber_purchase.flashes.success')
    expect(page).not_to have_content 'Receipt'

    expect_dashboard_to_show_workshop_active(in_person_section.workshop)
  end

  scenario 'show in-progress status for future online workshop' do
    online_section = create(:online_section, :ends_on => 2.days.from_now)

    sign_in_as_user_with_subscription
    click_online_workshop_detail_link
    click_link I18n.t('workshops.show.register_free')
    click_button 'Get Access'

    visit products_url
    expect(page).to have_css(".product-card.in-progress", text: online_section.name)
  end

  scenario 'show complete status for future online past workshop' do
    online_section = create(:in_person_section, :ends_on => 2.days.ago)

    get_access_to_in_person_workshop

    visit products_url
    expect(page).to have_css(".product-card.complete", text: online_section.name)
  end

  scenario 'show registered status for future in-person workshop' do
    online_section = create(:in_person_section, :ends_on => 2.days.from_now)

    get_access_to_in_person_workshop

    visit products_url
    expect(page).to have_css(".product-card.registered", text: online_section.name)
  end

  def get_access_to_in_person_workshop
    sign_in_as_user_with_subscription
    click_in_person_workshop_detail_link
    click_link I18n.t('workshops.show.register_free_inperson')
    fill_in 'subscriber_purchase_comments', with: 'Vegetarian'
    click_button 'Get Access'
  end

  def stub_github_fulfillment_job
    GithubFulfillmentJob.stubs(:enqueue)
  end

  def click_online_workshop_detail_link
    within('.workshop-online') do
      click_link 'View Details'
    end
  end

  def click_in_person_workshop_detail_link
    within('.workshop-in-person') do
      click_link 'View Details'
    end
  end

  def click_screencast_detail_link(screencast)
    within('.screencast') do
      click_link screencast.name
    end
  end

  def click_ebook_detail_link(book)
    within('section.books') do
      click_link book.name
    end
  end

  def expect_dashboard_to_show_workshop_active(workshop)
    visit products_url
    status = 'registered'
    if workshop.online?
      status = 'in-progress'
    end
    expect(page).to have_css(".product-card a[title='#{workshop.name}'] .status", text: status)
  end
end
