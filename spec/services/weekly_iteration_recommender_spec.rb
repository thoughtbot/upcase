require "rails_helper"

describe WeeklyIterationRecommender do
  describe "#recommend" do
    context "with video to recommend" do
      it "creates a recommendation" do
        user = create(:user)
        video = create(:video)

        expect do
          WeeklyIterationRecommender.new(
            user: user,
            sorted_recommendable_videos: [video]
          ).recommend
        end.to change { ContentRecommendation.count }.by(1)
      end

      it "enqueues email job" do
        user = create(:user)
        video = create(:video)
        allow(WeeklyIterationMailerJob)
          .to receive(:perform_later)
          .with(user.id, video.id)

        WeeklyIterationRecommender.new(
          user: user,
          sorted_recommendable_videos: [video]
        ).recommend

        expect(WeeklyIterationMailerJob).to have_received(:perform_later)
      end
    end

    context "with no video to recommend" do
      it "doesn't create a recommendation" do
        user = create(:user)
        video = create(:video)
        create(:content_recommendation, recommendable: video, user: user)

        expect do
          WeeklyIterationRecommender.new(
            user: user,
            sorted_recommendable_videos: [video]
          ).recommend
        end.not_to change_content_recommendation_count
      end

      it "doesn't enqueue email job" do
        user = create(:user)
        video = create(:video)
        create(:content_recommendation, recommendable: video, user: user)
        allow(WeeklyIterationMailerJob)
          .to receive(:perform_later)
          .with(user.id, video.id)

        WeeklyIterationRecommender.new(
          user: user,
          sorted_recommendable_videos: [video]
        ).recommend

        expect(WeeklyIterationMailerJob).not_to have_received(:perform_later)
      end

      def change_content_recommendation_count
        change { ContentRecommendation.count }
      end
    end
  end
end
