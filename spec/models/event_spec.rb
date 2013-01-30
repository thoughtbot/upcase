require 'spec_helper'

describe Event do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:time) }
  it { should validate_presence_of(:workshop_id) }

  it { should belong_to(:workshop) }

  context 'self.ordered' do
    it 'returns events in order by occurs_on_day' do
      event1 = create(:event, occurs_on_day: 37)
      event2 = create(:event, occurs_on_day: 1)
      Event.ordered.should == [event2, event1]
    end
  end
end
