require 'spec_helper'

describe Completion, :type => :model do
  it { should belong_to(:user) }

  it { should validate_uniqueness_of(:trail_object_id).scoped_to(:user_id) }
  it { should validate_presence_of(:trail_name) }
  it { should validate_presence_of(:slug) }

  context '.only_trail_object_ids' do
    it 'returns an array that only contains the trail object ids' do
      create(:trail, trail_map: FakeTrailMap.new.trail)
      completion = create(:completion, trail_object_id: 'test')

      expect(Completion.only_trail_object_ids).to eq ['test']
    end
  end

  context '#title' do
    it 'returns the title of an associated resource' do
      fake_trail_map = FakeTrailMap.new
      create(:trail, trail_map: fake_trail_map.trail)
      completion = create(:completion, trail_object_id: fake_trail_map.resource_id)

      expect(completion.title).to eq fake_trail_map.resource_title
    end

    it 'returns the title of an associated validation' do
      fake_trail_map = FakeTrailMap.new
      create(:trail, trail_map: fake_trail_map.trail)
      completion = create(:completion, trail_object_id: fake_trail_map.validation_id)

      expect(completion.title).to eq fake_trail_map.validation_title
    end

    it 'returns nil if there is no associated step' do
      fake_trail_map = FakeTrailMap.new
      create(:trail, trail_map: fake_trail_map.trail)
      completion = create(:completion, trail_object_id: 'nonexistent')

      expect(completion.title).to be_nil
    end
  end

  context '#trail_name=' do
    it 'sets the trail name and corresponding trail slug' do
      fake_trail_map = FakeTrailMap.new
      create(:trail, trail_map: fake_trail_map.trail, slug: 'git')
      completion = Completion.new

      completion.trail_name = fake_trail_map.name

      expect(completion.trail_name).to eq fake_trail_map.name
      expect(completion.slug).to eq 'git'
    end
  end
end
