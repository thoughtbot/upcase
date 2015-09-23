require "rails_helper"

describe Practice do
  describe "#has_completed_trails?" do
    it "returns false if there are no completed trails" do
      practice = Practice.new([])

      expect(practice).not_to have_completed_trails
    end

    it "returns true if it has completed trails" do
      trail = double("trail", complete?: true)
      practice = Practice.new([trail])

      expect(practice).to have_completed_trails
    end
  end

  describe "#just_finished_trails" do
    context "when there are recently-completed trails" do
      it "returns those trails" do
        trail = double("trail", just_finished?: true)

        result = Practice.new([trail]).just_finished_trails

        expect(result).to eq([trail])
      end
    end

    context "when the only trails are incomplete" do
      it "returns nothing" do
        trail = double("trail", just_finished?: false)

        result = Practice.new([trail]).just_finished_trails

        expect(result).to be_empty
      end
    end
  end

  describe "#unstarted_trails" do
    it "returns trails that the user hasn't started" do
      started_trail = double("started-trail", unstarted?: false)
      unstarted_trail = double("unstarted-trail", unstarted?: true)

      result = Practice.new([unstarted_trail, started_trail]).unstarted_trails

      expect(result).to eq([unstarted_trail])
    end
  end

  describe "#in_progress_trails" do
    it "returns trails the user has started" do
      in_progress_trail =
        double("in-progress-trail", in_progress?: true)
      not_in_progress_trail =
        double("not-in-progress-trail", in_progress?: false)

      result =
        Practice.
          new([in_progress_trail, not_in_progress_trail]).
          in_progress_trails

      expect(result).to eq([in_progress_trail])
    end
  end
end
