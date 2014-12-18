require "rails_helper"

describe TopicsController do
  it "renders topics CSS" do
    setup_stubbed_topics

    get :index, format: :css

    expect(assigns(:topics)).to be_present
    expect(response).to be_success
    expect(response).to render_template("topics/index")
    expect(response.headers["Content-Type"]).to match(/text\/css/)
    expect(response.headers["Cache-Control"]).to match(/max-age/)
  end

  def setup_stubbed_topics
    topics = [build_stubbed(:topic, updated_at: 1.month.ago)]
    Mocha::Configuration.allow(:stubbing_non_existent_method) do
      topics.stubs(:maximum).with(:updated_at).returns(Time.now)
    end
    Topic.stubs(:with_colors).returns(topics)
  end
end
