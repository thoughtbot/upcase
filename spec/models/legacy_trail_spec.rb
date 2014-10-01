require "rails_helper"

describe LegacyTrail do
  it { should belong_to(:topic) }

  it { should validate_presence_of(:topic_id) }
  it { should validate_presence_of(:slug) }

  it "gets its name from the trail map" do
    trail_map = FakeTrailMap.new.trail
    trail = build(:legacy_trail, trail_map: trail_map)

    expect(trail.name).to eq 'Git'
  end

  context '#total' do
    it 'is the number of validations' do
      trail_map = FakeTrailMap.new.trail
      trail = build(:legacy_trail, trail_map: trail_map)

      expect(trail.total).to eq 1
    end
  end

  context '#steps' do
    it 'returns an array of steps' do
      trail_map = FakeTrailMap.new.trail
      trail = build(:legacy_trail, trail_map: trail_map)

      expect(trail.steps.size).to eq 1
      expect(trail.steps.first).to eq LegacyStep.new(trail_map['steps'].first)
    end
  end

  context '#resources_and_validations' do
    it 'returns resources and validations for all steps' do
      trail = create(:legacy_trail, trail_map: FakeTrailMap.new.trail)

      expect(trail.resources_and_validations.size).to eq 2
    end

    it 'returns an array when a step has no resources or validations' do
      trail_without_resources = FakeTrailMap.new.trail
      trail_without_resources['steps'].first.delete('resources')
      trail_without_resources['steps'].first.delete('validations')

      trail = create(:legacy_trail, trail_map: trail_without_resources)

      expect(trail.resources_and_validations).to eq []
    end
  end

  context '#reference' do
    it 'returns reference resources for the trail' do
      trail = create(:legacy_trail, trail_map: FakeTrailMap.new.trail)

      expect(trail.reference.size).to eq 1
    end

    it 'returns an empty array when a trail has no references' do
      trail_without_reference = FakeTrailMap.new.trail
      trail_without_reference.delete('reference')

      trail = create(:legacy_trail, trail_map: trail_without_reference)

      expect(trail.reference).to be_empty
    end
  end
end
