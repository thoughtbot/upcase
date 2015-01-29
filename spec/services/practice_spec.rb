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
      trail =  create(:trail, :published)
      create(:status, :completed, completeable: trail, user: user)
      practice = Practice.new(user)

      expect(practice).to have_completed_trails
    end
  end

  describe "#completed_trails" do
    it "when there are completed trails" do
      user = create(:user)
      trail =  create(:trail, :published)
      create(:status, :completed, completeable: trail, user: user)
      practice = Practice.new(user)

      expect(practice.completed_trails).to eq([trail])
    end

    it "when there are incomplete trails" do
      user = create(:user)
      trail =  create(:trail, :published)
      create(:status, completeable: trail, user: user)
      practice = Practice.new(user)

      expect(practice.completed_trails).to be_empty
    end
  end

  describe "#active_trails" do
    it "when there are unstarted trails" do
      user = build_stubbed(:user)
      trail = create(:trail, published: true)
      practice = Practice.new(user)

      expect(practice.active_trails).to eq([trail])
    end

    it "when there are started trails" do
      user = build_stubbed(:user)
      trail = create(:trail, published: true)
      status = create(:status, completeable: trail, user: user)
      practice = Practice.new(user)

      expect(practice.active_trails).to eq([trail])
    end

    it "when there are other old completed trails" do
      user = build_stubbed(:user)
      trail = create(:trail, published: true)
      create(:status, :completed, completeable: trail, user: user)
      practice = Practice.new(user)

      expect(practice.active_trails).to be_empty
    end
  end
end
