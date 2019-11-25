require "rails_helper"

describe "Videos" do
  context "GET /" do
    it "provides RSS to distribute the Weekly Iteration to various channels" do
      show = create(
        :show,
        name: Show::THE_WEEKLY_ITERATION,
        short_description: "a description"
      )
      notes = "a" * 251
      published_videos = [
        create(:video, :published, watchable: show, summary: notes, published_on: 3.days.ago),
        create(:video, :published, watchable: show, summary: notes, published_on: 2.days.ago),
      ]
      video = create(:video, watchable: show)

      visit show_url(show)

      expect(page).to have_rss_link

      visit show_url(show, format: "rss")

      channel = Nokogiri::XML::Document.parse(page.body).xpath(".//rss/channel")

      expect(text_in(channel, ".//title")).to eq("The Weekly Iteration")
      expect(text_in(channel, ".//link")).to eq(show_url(show))
      expect(text_in(channel, ".//description")).to eq(show.short_description)

      unpublished_xpath = ".//item/title[text()='#{video.name}']"
      expect(channel.xpath(unpublished_xpath)).to be_empty

      published_videos.reverse.each_with_index do |published_video, index|
        item = channel.xpath(".//item")[index]

        expect(text_in(item, ".//title")).to eq(published_video.name)
        expect(text_in(item, ".//link")).
          to eq(video_url(published_video))

        expect(text_in(item, ".//guid")).
          to eq(video_url(published_video))

        expect(text_in(item, ".//pubDate")).
          to eq(published_video.created_at.to_s(:rfc822))

        expect(text_in(item, ".//description")).to match(/#{notes}/)
      end
    end
  end

  def text_in(node, xpath)
    node.xpath(xpath).first.text
  end

  def have_rss_link
    have_css("link[href*='the-weekly-iteration.rss']", visible: false)
  end
end
