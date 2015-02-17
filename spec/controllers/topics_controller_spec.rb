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
