require "rails_helper"

describe Practice do
  describe "#has_completed_trails?" do
    it "returns false if there are no completed trails" do
      practice = build_practice(trails: [])

      expect(practice).not_to have_completed_trails
    end

    it "returns true if it has completed trails" do
      trail = double("trail", complete?: true)
      practice = build_practice(trails: [trail])

      expect(practice).to have_completed_trails
    end
  end

  describe "#just_finished_trails" do
    context "when there are recently-completed trails" do
      it "returns those trails" do
        trail = double("trail", just_finished?: true)

        result = build_practice(trails: [trail]).just_finished_trails

        expect(result).to eq([trail])
      end
    end

    context "when the only trails are incomplete" do
      it "returns nothing" do
        trail = double("trail", just_finished?: false)

        result = build_practice(trails: [trail]).just_finished_trails

        expect(result).to be_empty
      end
    end
  end

  describe "#unpromoted_unstarted_trails" do
    it "returns trails that the user hasn't started and are unpromoted" do
      started_trail = build_trail(unstarted: false)
      unstarted_trail = build_trail(unstarted: true)
      promoted_unstarted_trail = build_trail(unstarted: true, promoted: true)
      trails = [unstarted_trail, started_trail, promoted_unstarted_trail]

      result = build_practice(trails: trails).unpromoted_unstarted_trails

      expect(result).to eq([unstarted_trail])
    end
  end

  describe "#in_progress_trails" do
    it "returns trails the user has started" do
      today = Date.today
      in_progress_trail =
        double("in-progress-trail", in_progress?: true, started_on: today)
      not_in_progress_trail =
        double("not-in-progress-trail", in_progress?: false, started_on: today)

      result =
        build_practice(trails: [in_progress_trail, not_in_progress_trail])
          .in_progress_trails

      expect(result).to eq([in_progress_trail])
    end
  end

  def build_practice(trails: [])
    Practice.new(trails: trails)
  end

  def build_trail(
    unstarted: false,
    in_progress: true,
    started_on: Date.today,
    promoted: false
  )
    double(
      "trail",
      unstarted?: unstarted,
      in_progress?: in_progress,
      started_on: started_on,
      promoted?: promoted
    )
  end
end
