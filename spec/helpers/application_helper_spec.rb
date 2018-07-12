require "rails_helper"

describe ApplicationHelper do
  describe "#exercise_path" do
    it "returns the remote URL for the exercise" do
      exercise = build_stubbed(:exercise)

      result = helper.exercise_path(exercise)

      expect(result).to eq(exercise.url)
    end
  end

  describe "#google_map_link_to" do
    it "links to a google map for an address" do
      address = "41 Winter Street, Boston MA 02108"

      result = helper.google_map_link_to(address)

      expect(result).to include("maps.google.com")
      expect(result).to include("q=41+Winter+Street")
    end
  end

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

  describe "#encourage_user_to_pay?" do
    context "when current_user has an active_subscription" do
      context "and is on a landing page" do
        it "returns true" do
          stub_user(subscriber: true, on_landing_page: true)

          result = helper.encourage_user_to_pay?

          expect(result).to be(true)
        end
      end

      context "and is not on a landing page" do
        it "returns false" do
          stub_user(subscriber: true, on_landing_page: false)

          result = helper.encourage_user_to_pay?

          expect(result).to be(false)
        end
      end
    end

    context "when current_user doesn't have an active_subscription" do
      context "and is on a landing page" do
        it "returns true" do
          stub_user(subscriber: false, on_landing_page: false)

          result = helper.encourage_user_to_pay?

          expect(result).to be(true)
        end
      end

      context "and is not on a landing page" do
        it "returns true" do
          stub_user(subscriber: false, on_landing_page: false)

          result = helper.encourage_user_to_pay?

          expect(result).to be(true)
        end
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

  def stub_user(subscriber:, on_landing_page:)
    user = double(:user, subscriber?: subscriber)
    allow(helper).to receive(:signed_out?).and_return(false)
    allow(helper).to receive(:current_user).and_return(user)
    assign(:landing_page, on_landing_page)
  end
end
