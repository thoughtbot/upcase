require "rails_helper"

RSpec.describe TrailWithProgressQuery do
  describe "#each" do
    it "yields each trail with progress" do
      user = create(:user)
      trail = create_trail_with_state(Status::COMPLETE, user: user)
      trails = TrailWithProgressQuery.new(Trail.all, user: user)
      result = []

      trails.each { |yielded| result << yielded }

      expect(result.map(&:name)).to eq([trail.name])
      expect(result.map(&:status).map(&:state)).to eq([Status::COMPLETE])
    end
  end

  describe "#find" do
    it "finds the given trail with progress" do
      user = create(:user)
      trail = create_trail_with_state(Status::COMPLETE, user: user)
      trails = TrailWithProgressQuery.new(Trail.all, user: user)

      result = trails.find(trail.to_param)

      expect(result.name).to eq(trail.name)
      expect(result).to be_complete
    end
  end

  def create_trail_with_state(state, user:)
    create(:trail).tap do |trail|
      create(:status, completeable: trail, user: user, state: state)
    end
  end
end
