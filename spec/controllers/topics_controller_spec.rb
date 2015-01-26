require "rails_helper"

describe TopicsController do
  context "#index" do
    it "renders topics CSS" do
      setup_stubbed_topics

      get :index, format: :css

      expect(response).to be_success
      expect(response.headers["Content-Type"]).to match(/text\/css/)
    end

    it "renders 406 for alternate formats" do
      expect do
        get :index, format: :json
        get :index, format: :html
      end.to raise_error(ActionController::UnknownFormat)
    end
  end

  context "#show" do
    it "renders the show page for a found topic" do
      topic = stubbed_topic
      Topic.stubs(:find).with(topic.to_param).returns(topic)

      get :show, id: topic

      expect(Topic).to have_received(:find).with(topic.to_param)
      expect(response).to be_success
      expect(response).to render_template "show"
    end

    it "renders 404 when a topic is not found" do
      expect do
        get :show, id: "rails"
      end.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).not_to render_template "show"
    end

    it "renders 406 when an invalid format is used" do
      topic = stubbed_topic
      Topic.stubs(:find).with(topic.to_param).returns(topic)

      expect do
        get :show, id: topic, format: "txt"
      end.to raise_error(ActionController::UnknownFormat)
      expect(response).not_to render_template "show"
    end
  end

  def setup_stubbed_topics
    topics = [stubbed_topic]
    Mocha::Configuration.allow(:stubbing_non_existent_method) do
      topics.stubs(:maximum).with(:updated_at).returns(Time.now)
    end
    Topic.stubs(:with_colors).returns(topics)
  end

  def stubbed_topic
    build_stubbed(
      :topic,
      slug: "topic",
      color: "red",
      color_accent: "yellow",
      updated_at: 1.month.ago
    )
  end
end
