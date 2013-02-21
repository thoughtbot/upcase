require 'spec_helper'

describe Event do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:time) }
  it { should validate_presence_of(:workshop_id) }

  it { should belong_to(:workshop) }

  describe 'self.ordered' do
    it 'returns events in order by occurs_on_day' do
      event1 = create(:event, occurs_on_day: 37)
      event2 = create(:event, occurs_on_day: 1)
      Event.ordered.should == [event2, event1]
    end
  end

  describe 'starts_today?' do
    it 'returns true when the event is today based on the given start date' do
      event = create(:event, occurs_on_day: 0)
      expect(event.starts_today?(Date.today)).to be_true
    end

    it 'returns false when the event is not today based on the given start date' do
      event = create(:event, occurs_on_day: 2)
      expect(event.starts_today?(Date.today)).not_to be_true
    end
  end

  describe 'event_on' do
    it 'gives the date the event will occur for the given start date' do
      start_date = 7.days.from_now.to_date
      event_one = create(:event, occurs_on_day: 0)
      event_two = create(:event, occurs_on_day: 2)

      expect(event_one.occurs_on(start_date)).to eq 7.days.from_now.to_date
      expect(event_two.occurs_on(start_date)).to eq 9.days.from_now.to_date
    end
  end
end
