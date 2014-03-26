require 'spec_helper'

feature 'Subscriber accesses content' do
  scenario 'begins a workshop' do
    workshop = create(:workshop)

    sign_in_as_user_with_subscription
    click_workshop_detail_link

    expect(page).to have_content I18n.t('workshops.show.free_to_subscribers')

    click_link I18n.t('workshops.show.register_free')

    expect(page).not_to have_content 'GitHub'
    click_button 'Get Access'

    expect(page).to have_content I18n.t('subscriber_purchase.flashes.success')
    expect(page).not_to have_content('Receipt')

    expect_dashboard_to_show_workshop_active(workshop)
  end

  scenario 'subscriber without access to workshops attempts to begin a workshop' do
    create(:workshop)
    create_mentors

    sign_in_as_user_with_downgraded_subscription
    click_workshop_detail_link

    expect(page).not_to have_content I18n.t('workshops.show.free_to_subscribers')
    expect(page).to have_content I18n.t('workshops.show.upgrade')

    click_link I18n.t('workshops.show.upgrade')

    expect(current_path).to eq edit_subscription_path
  end

  scenario 'gets access to a book product' do
    book = create(:book, :github)
    sign_in_as_user_with_subscription
    stub_github_fulfillment_job

    click_ebook_detail_link(book)
    click_link I18n.t('products.show.purchase_for_subscribed_user', offering_type: book.offering_type)
    click_button 'Get Access'

    expect(GithubFulfillmentJob).to have_received(:enqueue).
      with(
        book.github_team,
        [@current_user.github_username],
        Purchase.last.id
      )
  end

  scenario 'gets access to a screencast' do
    screencast = create(:screencast)
    create(:video, :published, watchable: screencast)
    sign_in_as_user_with_subscription
    click_screencast_detail_link(screencast)

    click_link 'Get this screencast'
    click_button 'Get Access'

    expect(page).to have_content('Watch or download video')
  end

  scenario "registering for overlapping workshops" do
    workshop = create(:workshop)
    overlapping_workshop = create(:workshop)

    sign_in_as_user_with_subscription
    click_link workshop.name
    click_link I18n.t('workshops.show.register_free')
    click_button 'Get Access'

    visit products_path

    click_link overlapping_workshop.name
    click_link I18n.t('workshops.show.register_free')
    expect(page).to have_content(I18n.t('workshops.overlapping'))
    click_button 'Get Access'
  end

  scenario 'show in-progress status for current workshop' do
    workshop = create(:workshop, length_in_days: 2)

    sign_in_as_user_with_subscription
    click_workshop_detail_link
    click_link I18n.t('workshops.show.register_free')
    click_button 'Get Access'

    visit dashboard_url
    expect(page).to have_css(".product-card.in-progress", text: workshop.name)
  end

  scenario 'show complete status for past workshop' do
    workshop = create(:workshop, length_in_days: 2)

    Timecop.travel(3.days.ago) do
      get_access_to_workshop
    end

    visit dashboard_url
    expect(page).to have_css(".product-card.complete", text: workshop.name)
  end

  def get_access_to_workshop
    sign_in_as_user_with_subscription
    click_workshop_detail_link
    click_link I18n.t('workshops.show.register_free')
    click_button 'Get Access'
  end

  def stub_github_fulfillment_job
    GithubFulfillmentJob.stubs(:enqueue)
  end

  def click_workshop_detail_link
    within('.workshop') do
      click_link 'View Details'
    end
  end

  def click_screencast_detail_link(screencast)
    within('.screencast') do
      click_link screencast.name
    end
  end

  def click_ebook_detail_link(book)
    within('section.reading') do
      click_link book.name
    end
  end

  def expect_dashboard_to_show_workshop_active(workshop)
    visit dashboard_path
    expect(page).to have_css(
      ".product-card a[title='#{workshop.name}'] .status",
      text: 'in-progress'
    )
  end
end
