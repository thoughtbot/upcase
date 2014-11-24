require "rails_helper"

describe Show do
  it_behaves_like "a class inheriting from Product"

  describe ".the_weekly_iteration" do
    it "finds the show named The Weekly Iteration" do
      show = create(:show, name: Show::THE_WEEKLY_ITERATION)

      result = Show.the_weekly_iteration

      expect(result).to eq show
    end
  end

  describe "#latest_video" do
    it "returns it's latest video" do
      show = create(:show)
      latest = Timecop.travel(1.days.ago) do
        create(:video, watchable: show)
      end
      Timecop.travel(2.days.ago) do
        create(:video, watchable: show)
      end

      expect(show.latest_video).to eq(latest)
    end
  end
end
