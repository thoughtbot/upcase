require "rails_helper"

describe "Videos" do
  context "GET /" do
    it "lists the published videos for a video_tutorial" do
      sign_in_as_user_with_subscription
      video_tutorial = create(:video_tutorial)
      published_video_one = create(
        :video,
        :published,
        watchable: video_tutorial,
        position: 1
      )
      published_video_two = create(
        :video,
        :published,
        watchable: video_tutorial,
        position: 2
      )
      video = create(:video, watchable: video_tutorial)

      visit video_tutorial_path(video_tutorial)

      expect(page).to have_content("2 lessons in this video tutorial")
      expect(page).to have_content(published_video_one.name)
      expect(page).to have_content(published_video_two.name)
      expect(page).not_to have_content(video.name)
      expect(
        page.body.index(published_video_one.name) <
        page.body.index(published_video_two.name)
      ).to be

      visit video_path(published_video_two)

      expect(page).to have_css("p.wistia-video")
    end

    it "lists the published videos for a product", js: true do
      sign_in_as_user_with_subscription

      video_tutorial = create(:video_tutorial)
      published_video_one = create(
        :video,
        :published,
        watchable: video_tutorial
      )
      published_video_two = create(
        :video,
        :published,
        watchable: video_tutorial
      )
      video = create(:video, watchable: video_tutorial)

      visit video_tutorial_path(video_tutorial)

      expect(page).to have_content(published_video_one.name)
      expect(page).to have_content(published_video_two.name)
      expect(page).to have_content("2 minutes")
      expect(page).not_to have_content(video.name)
    end

    it "doesn't say it's a series with one published video" do
      video_tutorial = create(:video_tutorial)
      create(:video, :published, watchable: video_tutorial)
      create(:video, watchable: video_tutorial)

      visit video_tutorial_path(video_tutorial)

      expect(page).not_to have_content("in the series")
      expect(page).not_to have_content("in this video_tutorial")
    end

    it "provides RSS to distribute the Weekly Iteration to various channels" do
      create(:plan, sku: Plan::THE_WEEKLY_ITERATION_SKU)
      show = create(
        :show,
        name: Show::THE_WEEKLY_ITERATION,
        short_description: "a description"
      )
      notes = "a" * 251
      published_videos = [
        create(:video, :published, watchable: show, position: 0, notes: notes),
        create(:video, :published, watchable: show, position: 1, notes: notes),
      ]
      video = create(:video, watchable: show)

      visit show_url(show)

      expect(page).to have_css("link[href*='the-weekly-iteration.rss']")

      visit show_url(show, format: "rss")

      channel = Nokogiri::XML::Document.parse(page.body).xpath(".//rss/channel")

      expect(text_in(channel, ".//title")).to eq("The Weekly Iteration")
      expect(text_in(channel, ".//link")).to eq(show_url(show))
      expect(text_in(channel, ".//description")).to eq(show.short_description)

      unpublished_xpath = ".//item/title[text()='#{video.name}']"
      expect(channel.xpath(unpublished_xpath)).to be_empty

      published_videos.each_with_index do |published_video, index|
        item = channel.xpath(".//item")[index]

        expect(text_in(item, ".//title")).to eq(published_video.name)
        expect(text_in(item, ".//link")).
          to eq(video_url(published_video))

        expect(text_in(item, ".//guid")).
          to eq(video_url(published_video))

        expect(text_in(item, ".//pubDate")).
          to eq(published_video.created_at.to_s(:rfc822))

        expect(text_in(item, ".//description")).to eq(notes.truncate(250))
      end
    end

    it "provides RSS to distribute the all videos to various channels" do
      show = create(:show)
      video_tutorial = create(:video_tutorial)
      notes = "a" * 251
      published_videos = [
        create(:video, :published, watchable: show, notes: notes),
        create(:video, :published, watchable: video_tutorial, notes: notes),
      ]
      video = create(:video, watchable: show)

      visit videos_url(format: "rss")

      channel = Nokogiri::XML::Document.parse(page.body).xpath(".//rss/channel")

      expect(text_in(channel, ".//title")).to eq("Upcase Videos")
      expect(text_in(channel, ".//link")).to eq(root_url)
      expect(text_in(channel, ".//description")).to eq(
        "Improve your programming skills with focused exercises."
      )

      unpublished_xpath = ".//item/title[text()='#{video.name}']"
      expect(channel.xpath(unpublished_xpath)).to be_empty

      published_videos.each_with_index do |published_video, index|
        item = channel.xpath(".//item")[index]

        expect(text_in(item, ".//title")).to eq(published_video.name)
        expect(text_in(item, ".//link")).
          to eq(video_url(published_video))

        expect(text_in(item, ".//guid")).
          to eq(video_url(published_video))

        expect(text_in(item, ".//pubDate")).
          to eq(published_video.created_at.to_s(:rfc822))

        expect(text_in(item, ".//description")).to eq(notes.truncate(250))
      end
    end

    def text_in(node, xpath)
      node.xpath(xpath).first.text
    end

    it "user visits The Weekly Iteration video and sees title for the show" do
      user = create(:user)
      show = create(:show)
      video = create(:video, watchable: show)

      visit video_path(video, as: user)

      expect_page_to_have_title("#{show.title} | Upcase")
    end
  end
end
