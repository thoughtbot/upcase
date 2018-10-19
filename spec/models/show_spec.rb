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
    it "returns its latest, published video" do
      show = create(:show)
      other_show = create(:show)
      create_video "older_published", show: show, published_on: 2.days.ago
      create_video "latest_published", show: show, published_on: 1.day.ago
      create_video "unpublished", show: show, published_on: 1.day.from_now
      create_video "other_show", show: other_show, published_on: Time.current

      expect(show.latest_video.name).to eq("latest_published")
    end

    def create_video(name, show:, published_on:)
      create(
        :video,
        name: name,
        watchable: show,
        published_on: published_on
      )
    end
  end
end
