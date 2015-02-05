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
      allow(Topic).to receive(:find).with(topic.to_param).and_return(topic)

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
      allow(Topic).to receive(:find).with(topic.to_param).and_return(topic)

      expect do
        get :show, id: topic, format: "txt"
      end.to raise_error(ActionController::UnknownFormat)
      expect(response).not_to render_template "show"
    end
  end

  def setup_stubbed_topics
    topics = [stubbed_topic]
    allow(topics).to receive(:maximum).with(:updated_at).and_return(Time.now)
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
