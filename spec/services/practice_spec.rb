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

  describe "#incomplete_trails" do
    it "when there are unstarted trails" do
      user = build_stubbed(:user)
      trail = create(:trail, :published)
      practice = Practice.new(user)

      expect(practice.incomplete_trails).to eq([trail])
    end

    it "when there are started trails" do
      user = build_stubbed(:user)
      trail = create(:trail, :published)
      create(:status, completeable: trail, user: user)
      practice = Practice.new(user)

      expect(practice.incomplete_trails).to eq([trail])
    end

    it "when there are completed trails" do
      user = build_stubbed(:user)
      trail = create(:trail, :published)
      Timecop.travel(1.week.ago) do
        create(:status, :completed, completeable: trail, user: user)
      end
      practice = Practice.new(user)

      expect(practice.incomplete_trails).to be_empty
    end

    context "sorting" do
      it "returns started trails before unstarted trails" do
        user = build_stubbed(:user)
        started_trail = create(:trail, :published, name: "Started")
        create(:status, completeable: started_trail, user: user)
        create(:trail, :published, name: "Unstarted")
        practice = Practice.new(user)

        result = practice.incomplete_trails

        expect(result.map(&:name)).to eq(["Started", "Unstarted"])
      end

      it "applies a secondary sort on topic" do
        topic = create(:topic)
        create(:trail, :published, topic: topic, name: "Trail with Topic 1")
        create(:trail, :published, topic: topic, name: "Trail with Topic 1")
        create(
          :trail,
          :published,
          topic: create(:topic),
          name: "Trail with Topic 2"
        )
        create(
          :trail,
          :published,
          topic: create(:topic),
          name: "Trail with Topic 3"
        )
        practice = Practice.new(build_stubbed(:user))

        result = practice.incomplete_trails

        expect(result.map(&:name)).to(
          eq(["Trail with Topic 1",
              "Trail with Topic 1",
              "Trail with Topic 2",
              "Trail with Topic 3"])
        )
      end
    end
  end
end
