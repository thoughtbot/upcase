require "rails_helper"

describe Practice do
  describe "#has_completed_trails?" do
    it "returns false if it has no completed trails" do
      user = build_stubbed(:user)
      practice = Practice.new(user)

      expect(practice).not_to have_completed_trails
    end

    it "returns true if it has completed published trails" do
      user = create(:user)
      trail = create(:trail, :published)
      create(:status, :completed, completeable: trail, user: user)
      practice = Practice.new(user)

      expect(practice).to have_completed_trails
    end
  end

  describe "#just_finished_trails" do
    it "when there are recently completed trails" do
      user = create(:user)
      trail = create(:trail, :published)
      create(:status, :completed, completeable: trail, user: user)
      practice = Practice.new(user)

      expect(practice.just_finished_trails).to eq([trail])
    end

    it "when there are incomplete trails" do
      user = create(:user)
      trail = create(:trail, :published)
      create(:status, completeable: trail, user: user)
      practice = Practice.new(user)

      expect(practice.just_finished_trails).to be_empty
    end
  end

  describe "#unstarted_trails" do
    it "returns trails that the user hasn't started" do
      user = build_stubbed(:user)
      started_trail = create(:trail, :published, name: "Started")
      create(:status, completeable: started_trail, user: user)
      create(:trail, :published, name: "Unstarted")
      practice = Practice.new(user)

      result = practice.unstarted_trails

      expect(result.map(&:name)).to eq(["Unstarted"])
    end
  end

  describe "#in_progress_trails" do
    it "returns trails the user has started" do
      user = build_stubbed(:user)
      started_trail = create(:trail, :published, name: "Started")
      create(:status, completeable: started_trail, user: user)
      create(:trail, :published, name: "Unstarted")
      practice = Practice.new(user)

      result = practice.in_progress_trails

      expect(result.map(&:name)).to eq(["Started"])
    end
  end
end
