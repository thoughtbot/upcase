require 'spec_helper'

describe 'Videos' do
  context 'GET /' do
    it 'indicates available videos for a workshop' do
      workshop = create(:workshop)
      section = create(:section, starts_on: Date.yesterday, ends_on: 1.month.from_now, workshop: workshop)
      video_one = create_available_video(workshop, 0, 'Video One')
      video_two = create_available_video(workshop, 2, 'Video Two')
      purchase = create(:paid_purchase, purchaseable: section)

      visit purchase_path(purchase)
      expect(page).to have_content("2 lessons in this workshop")
      expect(page).to have_content(video_one.title)
      expect(page).to have_content(video_two.title)
      expect(page.body.index(video_one.title) < page.body.index(video_two.title)).to be
      expect(page).to have_css('.available > a', text: video_one.title)
      expect(page).to have_css('.unavailable > div', text: video_two.title)
      expect(page).to have_css('.unavailable > div', text: "Starts on #{Date.tomorrow.to_s(:simple)}")

      visit purchase_video_path(purchase, video_two)
      expect(page).to_not have_css('iframe')
    end

    it 'indicates available videos for a product' do
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

    def create_available_video(watchable, active_on_day, title)
      create(:video, watchable: watchable, active_on_day: active_on_day, title: title)
    end
  end
end
