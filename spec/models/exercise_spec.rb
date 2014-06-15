require 'spec_helper'

describe Exercise do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:url) }

  context '.ordered' do
    it 'returns exercises in order by position' do
      exercise_lowest = create(:exercise, position: 1)
      exercise_highest = create(:exercise, position: 3)
      exercise_middle = create(:exercise, position: 2)
      Exercise.ordered.should match_array(
        [exercise_lowest, exercise_middle, exercise_highest]
      )
    end
  end
end
