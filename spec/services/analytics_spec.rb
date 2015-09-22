require "rails_helper"

describe Analytics do
  let(:user) { build_stubbed(:user) }
  let(:analytics_instance) { Analytics.new(user) }

  describe "#track_updated" do
    it "sends updated identify event to backend" do
      analytics_instance.track_updated

      expect(analytics).to have_identified(user).
        with_properties(analytics_instance.identify_hash(user))
    end
  end

  describe "#track_video_started" do
    it "tracks started video event" do
      video = build_stubbed(:video)

      analytics_instance.track_video_started(
        name: video.name,
        watchable_name: video.watchable_name,
      )

      expect(analytics).to have_tracked("Started video").
        for_user(user).
        with_properties(
          name: video.name,
          watchable_name: video.watchable_name,
        )
    end

    it "also tracks video touched event" do
      video = build_stubbed(:video)

      analytics_instance.track_video_started(
        name: video.name,
        watchable_name: video.watchable_name,
      )

      expect(analytics).to have_tracked("Touched Video").
        for_user(user).
        with_properties(
          name: video.name,
          watchable_name: video.watchable_name,
        )
    end
  end

  describe "#track_video_finished" do
    it "tracks finished video event" do
      video = build_stubbed(:video)

      analytics_instance.track_video_finished(
        name: video.name,
        watchable_name: video.watchable_name,
      )

      expect(analytics).to have_tracked("Finished video").
        for_user(user).
        with_properties(
          name: video.name,
          watchable_name: video.watchable_name,
        )
    end
  end

  describe "#track_searched" do
    it "tracks the searched-for query and results count" do
      analytics_instance.track_searched(query: "hey", results_count: 1)

      expect(analytics).to have_tracked("Searched").
        for_user(user).
        with_properties(query: "hey", results_count: 1)
    end
  end

  describe "#track_collaborated" do
    it "tracks that the user created a collaboration" do
      analytics_instance.track_collaborated(repository_name: "upcase")

      expect(analytics).to have_tracked("Created Collaboration").
        for_user(user).
        with_properties(repository_name: "upcase")
    end
  end

  describe "#track_accessed_forum" do
    it "tracks that the user accessed the forum" do
      analytics_instance.track_accessed_forum

      expect(analytics).to have_tracked("Logged into Forum").for_user(user)
    end
  end

  describe "#track_cancelled" do
    it "tracks that the user cancelled along with the reason" do
      analytics_instance.track_cancelled(reason: "No good")

      expect(analytics).to have_tracked("Cancelled").
        for_user(user).
        with_properties(reason: "No good")
    end
  end

  describe "#track_flashcard_attempted" do
    it "tracks the flashcard and deck from the attempt" do
      flashcard_properties = {
        deck: "Ruby Questions",
        title: "What Is Better Than A For Loop?",
      }

      analytics_instance.track_flashcard_attempted(flashcard_properties)

      expect(analytics).to have_tracked("Flashcard Attempted").
        for_user(user).
        with_properties(flashcard_properties)
    end
  end

  describe "#track_downloaded" do
    it "records the video and watchable name" do
      video = create(:video)

      download_properties = {
        name: video.name,
        watchable_name: video.watchable_name,
        download_type: "Original",
      }

      analytics_instance.track_downloaded(download_properties)

      expect(analytics).to have_tracked("Downloaded Video").
        for_user(user).
        with_properties(download_properties)
    end

    it "also tracks video touched event" do
      video = build_stubbed(:video)

      analytics_instance.track_video_started(
        name: video.name,
        watchable_name: video.watchable_name,
      )

      expect(analytics).to have_tracked("Touched Video").
        for_user(user).
        with_properties(
          name: video.name,
          watchable_name: video.watchable_name,
        )
    end
  end
end
