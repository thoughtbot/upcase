require 'spec_helper'

describe FollowUp do
  # Database
  it { should have_db_column(:created_at) }
  it { should have_db_column(:updated_at) }
  it { should have_db_index(:course_id) }

  # Mass Assignment
  it { should allow_mass_assignment_of(:email) }

  # Associations
  it { should belong_to(:course) }

  # Validations
  it { should validate_presence_of(:email) }
  it { should_not allow_value('foo').for(:email) }
  it { should allow_value('foo@example.com').for(:email) }

  describe '#notify' do
    it 'delivers Mailer.follow_up' do
      mail_message = mock('Mail::Message')
      mail_message.stubs :deliver
      Mailer.stubs(:follow_up).returns mail_message
      follow_up = build(:follow_up)
      follow_up.notify build(:section)
      Mailer.should have_received(:follow_up)
      mail_message.should have_received(:deliver)
    end

    it 'sets #notified_at' do
      follow_up = build(:follow_up, notified_at: nil)
      follow_up.notify build(:section)
      follow_up.notified_at.should be_present
    end

    it 'persists' do
      follow_up = build(:follow_up)
      follow_up.notify build(:section)
      follow_up.should be_persisted
    end
  end
end
