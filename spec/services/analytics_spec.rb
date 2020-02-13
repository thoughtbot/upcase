require "rails_helper"

describe Analytics do
  let(:user) { build_stubbed(:user) }
  let(:analytics_instance) { Analytics.new(user) }

  describe "any individual tracking call" do
    it "includes the user's email as a properties" do
      analytics_instance.track_accessed_forum

      expect(analytics).to(
        have_tracked("Logged into Forum").
        with_properties(email: user.email)
      )
    end

    context "if the user is signed in" do
      it "identifies the user when tracking" do
        user = create(:user)
        user_analytics_instance = Analytics.new(user)

        user_analytics_instance.track_accessed_forum

        expect(analytics).to(
          have_tracked("Logged into Forum")
        )
      end
    end
  end

  describe "#track_updated" do
    it "sends updated identify event to backend" do
      analytics_instance.track_updated

      expect(analytics).to have_identified(user).
        with_properties(analytics_instance.identify_hash(user))
    end
  end

  describe "#track_completeable_started" do
    context "with a video" do
      it "tracks started video event" do
        video = build_stubbed(:video)

        analytics_instance.track_completeable_started(video)

        expect(analytics).to have_tracked("Started video").
          for_user(user).
          with_properties(
            name: video.name,
            watchable_name: video.watchable_name,
          )
      end

      it "also tracks video touched event" do
        video = build_stubbed(:video)

        analytics_instance.track_completeable_started(video)

        expect(analytics).to have_tracked("Touched Video").
          for_user(user).
          with_properties(
            name: video.name,
            watchable_name: video.watchable_name,
          )
      end

      it "also tracks step touched event" do
        video = build_stubbed(:video)

        analytics_instance.track_completeable_started(video)

        expect(analytics).to have_tracked("Touched Step").
          for_user(user).
          with_properties(
            name: video.name,
            watchable_name: video.watchable_name,
            type: "Video",
          )
      end
    end

    context "with an exercise" do
      it "tracks started exercise event" do
        exercise = build_stubbed(:exercise)

        analytics_instance.track_completeable_started(exercise)

        expect(analytics).to have_tracked("Started exercise").
          for_user(user).
          with_properties(
            name: exercise.name,
            watchable_name: exercise.trail_name,
          )
      end

      it "also tracks step touched event" do
        exercise = build_stubbed(:exercise)

        analytics_instance.track_completeable_started(exercise)

        expect(analytics).to have_tracked("Touched Step").
          for_user(user).
          with_properties(
            name: exercise.name,
            watchable_name: exercise.trail_name,
            type: "Exercise",
          )
      end
    end

    context "with a trail" do
      it "tracks started trail event" do
        trail = build_stubbed(:trail)

        analytics_instance.track_completeable_started(trail)

        expect(analytics).to have_tracked("Started trail").
          for_user(user).
          with_properties(name: trail.name)
      end
    end
  end

  describe "#track_completeable_finished" do
    context "with a video" do
      it "tracks finished video event" do
        video = build_stubbed(:video)

        analytics_instance.track_completeable_finished(video)

        expect(analytics).to have_tracked("Finished video").
          for_user(user).
          with_properties(
            name: video.name,
            watchable_name: video.watchable_name,
          )
      end
    end

    context "with an exercise" do
      it "tracks finished exercise event" do
        exercise = build_stubbed(:exercise)

        analytics_instance.track_completeable_finished(exercise)

        expect(analytics).to have_tracked("Finished exercise").
          for_user(user).
          with_properties(
            name: exercise.name,
            watchable_name: exercise.trail_name,
          )
      end
    end

    context "with a trail" do
      it "tracks finished exercise event" do
        trail = build_stubbed(:trail)

        analytics_instance.track_completeable_finished(trail)

        expect(analytics).to have_tracked("Finished trail").
          for_user(user).
          with_properties(name: trail.name)
      end
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

  describe "#track_accessed_forum" do
    it "tracks that the user accessed the forum" do
      analytics_instance.track_accessed_forum

      expect(analytics).to have_tracked("Logged into Forum").for_user(user)
    end
  end

  describe "#track_cancelled" do
    it "tracks that the user cancelled along with the reason and their email" do
      analytics_instance.track_cancelled(reason: "No good")

      expect(analytics).to have_tracked("Cancelled").
        for_user(user).
        with_properties(reason: "No good", email: user.email)
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

      download_properties = {
        name: video.name,
        watchable_name: video.watchable_name,
        download_type: "Original",
      }

      analytics_instance.track_downloaded(download_properties)

      expect(analytics).to have_tracked("Touched Video").
        for_user(user).
        with_properties(
          name: video.name,
          watchable_name: video.watchable_name,
        )
    end

    it "also tracks step touched event" do
      video = build_stubbed(:video)

      download_properties = {
        name: video.name,
        watchable_name: video.watchable_name,
        download_type: "Original",
      }

      analytics_instance.track_downloaded(download_properties)

      expect(analytics).to have_tracked("Touched Step").
        for_user(user).
        with_properties(
          name: video.name,
          watchable_name: video.watchable_name,
          type: "Video",
        )
    end
  end

  describe "#track_account_created" do
    it "tracks that a new account was created" do
      analytics_instance.track_account_created

      expect(analytics).to have_tracked("Account created").for_user(user)
    end
  end
end
