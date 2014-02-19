require 'spec_helper'

describe 'Videos' do
  context 'get show' do
    it 'does not allow watching a video without paying first' do
      product = create(:screencast)
      video = create(:video, watchable: product)
      purchase = create(:unpaid_purchase, purchaseable: product)
      purchase.lookup = 'unpaid'
      purchase.save!

      visit purchase_path(purchase)

      expect(current_path).to eq screencast_path(product)

      visit purchase_video_path(purchase, video)

      expect(current_path).to eq screencast_path(product)
    end
  end

  context 'GET /' do
    it 'lists the videos for a workshop' do
      workshop = create(:workshop)
      video_one = create(:video, watchable: workshop, position: 1)
      video_two = create(:video, watchable: workshop, position: 2)
      purchase = create_subscriber_purchase_from_purchaseable(workshop)

      visit purchase_path(purchase)

      expect(page).to have_content("2 lessons in this workshop")
      expect(page).to have_content(video_one.title)
      expect(page).to have_content(video_two.title)
      expect(page.body.index(video_one.title) < page.body.index(video_two.title)).to be

      visit purchase_video_path(purchase, video_two)

      expect(page).to have_css('iframe')
    end

    it 'lists the videos for a product' do
      purchase = create(:screencast_purchase)
      video_one = create(:video, watchable: purchase.purchaseable)
      video_two = create(:video, watchable: purchase.purchaseable)

      visit purchase_path(purchase)

      expect(page).to have_content("2 videos in the series")
      expect(page).to have_content(video_one.title)
      expect(page).to have_content(video_two.title)
    end

    it "doesn't say it's a series with one video" do
      purchase = create(:screencast_purchase)
      video_one = create(:video, watchable: purchase.purchaseable)

      visit purchase_path(purchase)

      expect(page).not_to have_content("in the series")
      expect(page).not_to have_content("in this workshop")
    end

    it "doesn't say it includes support with no subscription" do
      purchase = create(:screencast_purchase)
      create(:video, watchable: purchase.purchaseable)

      visit purchase_path(purchase)

      expect(page).not_to have_content("includes support")
    end

    it 'includes support with a subscription' do
      sign_in_as_user_with_subscription

      purchase = create(:screencast_purchase)
      create(:video, watchable: purchase.purchaseable)

      visit purchase_path(purchase)

      expect(page).to have_content("includes support")
    end

    it 'redirects subscribers from Weekly Iteration landing page' do
      sign_in_as_user_with_subscription

      show = create(:show, name: Show::THE_WEEKLY_ITERATION)

      visit '/the-weekly-iteration'

      expect(page.current_path).to eq show_path(show)
    end

    it 'provides RSS to distribute the Weekly Iteration to various channels' do
      create(:plan, sku: IndividualPlan::PRIME_BASIC_SKU)
      create(:show, name: Show::THE_WEEKLY_ITERATION)

      visit '/the-weekly-iteration'

      expect(page).to have_css("link[href*='the-weekly-iteration.rss']")

      visit '/the-weekly-iteration.rss'

      expect(page).to have_xpath(
        '//rss/channel/title',
        text: 'The Weekly Iteration'
      )
    end

    it 'encourages subscribers to purchase The Weekly Iteration' do
      user = create(:subscriber)
      show = create(:show)
      video = create(:video, watchable: show)

      visit public_video_path(video, as: user)

      expect(page).to have_content 'Get this show'
    end
  end
end
