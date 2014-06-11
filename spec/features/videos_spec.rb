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
    it 'lists the published videos for a workshop', js: true do
      workshop = create(:workshop)
      published_video_one = create(
        :video,
        :published,
        watchable: workshop,
        position: 1
      )
      published_video_two = create(
        :video,
        :published,
        watchable: workshop,
        position: 2
      )
      video = create(:video, watchable: workshop)
      purchase = create_subscriber_purchase_from_purchaseable(workshop)

      visit purchase_path(purchase)

      expect(page).to have_content("2 lessons in this workshop")
      expect(page).to have_content(published_video_one.title)
      expect(page).to have_content(published_video_two.title)
      expect(page).not_to have_content(video.title)
      expect(
        page.body.index(published_video_one.title) <
        page.body.index(published_video_two.title)
      ).to be

      visit purchase_video_path(purchase, published_video_two)

      expect(page).to have_css('iframe')
    end

    it 'lists the published videos for a product', js: true do
      purchase = create(:screencast_purchase)
      published_video_one = create(
        :video,
        :published,
        watchable: purchase.purchaseable
      )
      published_video_two = create(
        :video,
        :published,
        watchable: purchase.purchaseable
      )
      video = create(:video, watchable: purchase.purchaseable)

      visit purchase_path(purchase)

      expect(page).to have_content("2 videos in the series")
      expect(page).to have_content(published_video_one.title)
      expect(page).to have_content(published_video_two.title)
      expect(page).to have_content("2 minutes")
      expect(page).not_to have_content(video.title)
    end

    it "doesn't say it's a series with one published video" do
      purchase = create(:screencast_purchase)
      create(:video, :published, watchable: purchase.purchaseable)
      create(:video, watchable: purchase.purchaseable)

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
      create(:video, :published, watchable: purchase.purchaseable)

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
      show = create(
        :show,
        name: Show::THE_WEEKLY_ITERATION,
        short_description: 'a description'
      )
      notes = 'a' * 251
      published_videos = [
        create(:video, :published, watchable: show, position: 0, notes: notes),
        create(:video, :published, watchable: show, position: 1, notes: notes),
      ]
      video = create(:video, watchable: show)

      visit '/the-weekly-iteration'

      expect(page).to have_css("link[href*='the-weekly-iteration.rss']")

      visit '/the-weekly-iteration.rss'

      channel = Nokogiri::XML::Document.parse(page.body).xpath('.//rss/channel')

      expect(text_in(channel, './/title')).to eq('The Weekly Iteration')
      expect(text_in(channel, './/link')).to eq(weekly_iteration_url)
      expect(text_in(channel, './/description')).to eq(show.short_description)

      unpublished_xpath = ".//item/title[text()='#{video.title}']"
      expect(channel.xpath(unpublished_xpath)).to be_empty

      published_videos.each_with_index do |published_video, index|
        item = channel.xpath('.//item')[index]

        expect(text_in(item, './/title')).to eq(published_video.title)
        expect(text_in(item, './/link')).
          to eq(public_video_url(published_video))

        expect(text_in(item, './/guid')).
          to eq(public_video_url(published_video))

        expect(text_in(item, './/pubDate')).
          to eq(published_video.created_at.to_s(:rfc822))

        expect(text_in(item, './/description')).to eq(notes.truncate(250))
      end
    end

    def text_in(node, xpath)
      node.xpath(xpath).first.text
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
