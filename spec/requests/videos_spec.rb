require 'spec_helper'

describe 'Videos' do
  context 'get show' do
    it 'does not allow watching a video without paying first' do
      product = create(:video_product)
      video = create_available_video(product, 0, 'Video One')
      purchase = create(:unpaid_purchase, purchaseable: product)
      purchase.lookup = 'unpaid'
      purchase.save!

      visit purchase_path(purchase)

      expect(current_path).to eq product_path(product)

      visit purchase_video_path(purchase, video)

      expect(current_path).to eq product_path(product)
    end
  end

  context 'GET /' do
    it 'lists the videos for a workshop' do
      workshop = create(:workshop)
      section = create(:section, starts_on: Date.yesterday, ends_on: 1.month.from_now, workshop: workshop)
      video_one = create_available_video(workshop, 0, 'Video One')
      video_two = create_available_video(workshop, 2, 'Video Two')
      purchase = create_subscriber_purchase_from_purchaseable(section)

      visit purchase_path(purchase)

      expect(page).to have_content("2 lessons in this workshop")
      expect(page).to have_content(video_one.title)
      expect(page).to have_content(video_two.title)
      expect(page.body.index(video_one.title) < page.body.index(video_two.title)).to be

      visit purchase_video_path(purchase, video_two)

      expect(page).to have_css('iframe')
    end

    it 'lists the videos for a product' do
      purchase = create(:video_purchase)
      video_one = create_available_video(purchase.purchaseable, 0, 'Video One')
      video_two = create_available_video(purchase.purchaseable, 0, 'Video Two')

      visit purchase_path(purchase)

      expect(page).to have_content("2 videos in the series")
      expect(page).to have_content(video_one.title)
      expect(page).to have_content(video_two.title)
    end

    it "doesn't say it's a series with one video" do
      purchase = create(:video_purchase)
      video_one = create_available_video(purchase.purchaseable, 0, 'Video One')

      visit purchase_path(purchase)
      expect(page).not_to have_content("in the series")
      expect(page).not_to have_content("in this workshop")
    end

    it "doesn't say it includes support with no subscription" do
      purchase = create(:video_purchase)

      visit purchase_path(purchase)
      expect(page).not_to have_content("includes support")
    end

    it 'includes support with a subscription' do
      sign_in_as_user_with_subscription

      purchase = create(:video_purchase)

      visit purchase_path(purchase)
      expect(page).to have_content("includes support")
    end
  end

  def create_available_video(watchable, active_on_day, title)
    create(:video, watchable: watchable, active_on_day: active_on_day, title: title)
  end
end
