require "rails_helper"

describe Explore do
  describe "#show" do
    it "returns The Weekly Iteration" do
      user = double
      twi_show = double
      allow(Show).to receive(:the_weekly_iteration).and_return(twi_show)

      show = Explore.new(user).show

      expect(show).to eq(twi_show)
    end
  end

  describe "#latest_video_trail" do
    it "returns most recent published video trail" do
      user = double(:user)
      create_trail("Video Trail", published: 1.day.ago, type: :video)
      create_trail("Old Trail", published: 2.days.ago, type: :video)
      create_trail("Unpublished Trail", published: false, type: :video)
      create_trail("Exercise Trail", published: Time.now, type: :exercise)

      result = Explore.new(user).latest_video_trail

      expect(result.name).to eq("Video Trail")
    end

    def create_trail(name, published:, type:)
      trail = create(
        :trail,
        name: name,
        published: published.present?,
        created_at: published || Time.now
      )

      create(
        :step,
        trail: trail,
        completeable: create(type)
      )
    end
  end

  describe "#trails" do
    it "returns most recently published Trails" do
      user = double
      explore = Explore.new(user)

      expect(explore.trails).to find_relation(Trail.most_recent_published)
    end
  end
end
