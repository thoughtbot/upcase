require "rails_helper"

describe ApplicationHelper do
  describe "#format_markdown" do
    it "returns the rendered html for the input markdown" do
      markdown = "hello **world**"

      formatted = helper.format_markdown(markdown)

      expect(formatted).to eq("<p>hello <strong>world</strong></p>\n")
    end

    context "with an empty input" do
      it "returns an empty string" do
        expect(helper.format_markdown(nil)).to eq("")
      end
    end
  end

  describe "#content_meta_description" do
    context "when the content has a meta_description defined" do
      it "uses the provided meta_description" do
        meta_description = "hello world"
        topic = double(:topic, meta_description: meta_description)

        result = helper.content_meta_description(topic)

        expect(result).to eq(meta_description)
      end
    end

    context "when the meta_description is empty" do
      it "uses the content's name to build a description" do
        video = double(:video, meta_description: "", name: "Middleman")
        expected_title = t("shared.content_meta_description", name: video.name)

        result = helper.content_meta_description(video)

        expect(result).to eq(expected_title)
      end
    end
  end

  describe "#dynamic_page_title" do
    context "when a specific page title has been set" do
      it "returns that page title" do
        title = "hello world"
        topic = create(:topic, page_title: title)

        result = helper.dynamic_page_title(topic, "topic")

        expect(result).to eq(title)
      end
    end

    context "when there is not specific page title set" do
      it "returns a page title including the topic name" do
        video = create(:topic, page_title: "", name: "Page Objects")
        expected = t("dynamic_page_titles.video", name: video.name)

        result = helper.dynamic_page_title(video, "video")

        expect(result).to eq(expected)
      end
    end
  end

  def create_trail_video(topic)
    create(:trail, :published, name: "Video Trail").tap do |trail|
      video = create(:video, watchable: trail, topics: [topic])
      create(:step, trail: trail, completeable: video)
    end
  end
end
