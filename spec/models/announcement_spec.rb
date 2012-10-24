require 'spec_helper'

describe Announcement do
  # Database
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index(:announceable_id) }

  # Mass Assignment
  it { should allow_mass_assignment_of(:announceable_id) }
  it { should allow_mass_assignment_of(:announceable_type) }
  it { should allow_mass_assignment_of(:ends_at) }
  it { should allow_mass_assignment_of(:message) }

  # Associations
  it { should belong_to(:announceable) }

  # Validations
  it { should validate_presence_of(:announceable_id) }
  it { should validate_presence_of(:announceable_type) }
  it { should validate_presence_of(:ends_at) }
  it { should validate_presence_of(:message) }

  context '.current' do
    context 'without any announcements' do
      it 'returns nil' do
        expect(Announcement.current).to be_nil
      end
    end

    context 'with multiple announcements' do
      it 'returns the announcement with the earliest active ends_at' do
        create :announcement, ends_at: Time.now.yesterday
        create :announcement, ends_at: Time.now.next_week
        current = create(:announcement, ends_at: Time.now.tomorrow)
        expect(Announcement.current).to eq(current)
      end
    end
  end
end
