require "rails_helper"

RSpec.describe WeeklyIterationSuggestions do
  describe "#perform" do
    it "calls WeeklyIterationRecommender for each user" do
      user = create(:user)
      video = create(:recommendable_content).recommendable

      recommender = stub_weekly_iteration_recommender_with(
        user: user,
        sorted_recommendable_videos: [video]
      )

      WeeklyIterationSuggestions.new([user]).send

      expect(recommender).to have_received(:recommend).once
    end
  end

  def stub_weekly_iteration_recommender_with(args)
    double("recommender", recommend: true).tap do |recommender|
      allow(WeeklyIterationRecommender)
        .to receive(:new)
        .with(args)
        .and_return(recommender)
    end
  end
end
