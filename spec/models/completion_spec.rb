require 'spec_helper'

describe Completion do
  it { should belong_to(:user) }

  it { should validate_uniqueness_of(:trail_object_id).scoped_to(:user_id) }
  it { should validate_presence_of(:trail_name) }

  context 'only_trail_object_ids' do
    it 'returns an array that only contains the trail object ids' do
      completion = create(:completion, trail_object_id: 'test')

      expect(Completion.only_trail_object_ids).to eq ['test']
    end
  end
end
