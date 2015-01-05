require "rails_helper"

describe TopicsController do
  it "renders topics CSS" do
    setup_stubbed_topics

    get :index, format: :css

    expect(response).to be_success
    expect(response.headers["Content-Type"]).to match(/text\/css/)
  end

  def setup_stubbed_topics
    topics = [topic]
    Mocha::Configuration.allow(:stubbing_non_existent_method) do
      topics.stubs(:maximum).with(:updated_at).returns(Time.now)
    end
    Topic.stubs(:with_colors).returns(topics)
  end

  def topic
    build_stubbed(
      :topic,
      slug: "topic",
      color: "red",
      color_accent: "yellow",
      updated_at: 1.month.ago
    )
  end
end
