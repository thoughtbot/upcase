require 'spec_helper'

describe 'Videos' do
  context 'GET /' do
    it 'indicates available videos' do
      workshop = create(:workshop)
      section = create(:section, starts_on: Date.today, ends_on: 1.month.from_now, workshop: workshop)
      video_one = create(:video, watchable: workshop, active_on_day: 0, title: 'Video One')
      video_two = create(:video, watchable: workshop, active_on_day: 2, title: 'Video Two')
      purchase = create(:paid_purchase, purchaseable: section)

      visit watch_purchase_path(purchase)
      expect(page).to have_content("2 videos in the series")
      expect(page).to have_content(video_one.title)
      expect(page).to have_content(video_two.title)
      expect(page.body.index(video_one.title) < page.body.index(video_two.title)).to be
      expect(page).to have_css('div.available > a > p', text: video_one.title)
      expect(page).to have_css('div.unavailable > p', text: video_two.title)
      expect(page).to have_css('div.unavailable > p', text: "Available on #{2.days.from_now.to_s(:simple)}")
      visit purchase_video_path(purchase, video_two)
      expect(page).to_not have_css('iframe')
    end
  end
end
