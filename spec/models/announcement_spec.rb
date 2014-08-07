require 'spec_helper'

describe Announcement, :type => :model do
  # Database
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index([:announceable_id, :announceable_type, :ends_at]) }

  # Associations
  it { should belong_to(:announceable) }

  # Validations
  it { should validate_presence_of(:announceable_id) }
  it { should validate_presence_of(:announceable_type) }
  it { should validate_presence_of(:ends_at) }
  it { should validate_presence_of(:message) }

  describe '.current' do
    context 'without any announcements' do
      it 'returns nil' do
        expect(Announcement.current).to be_nil
      end
    end

    context 'with multiple announcements' do
      it 'returns the announcement with the earliest active ends_at' do
        create :announcement, ends_at: Time.now.yesterday
        create :announcement, ends_at: 7.days.from_now
        current = create(:announcement, ends_at: 1.day.from_now)
        expect(Announcement.current).to eq current
      end
    end
  end
end
