require 'spec_helper'

describe FollowUp do
  # Database
  it { should have_db_column(:created_at) }
  it { should have_db_column(:updated_at) }
  it { should have_db_index(:workshop_id) }

  # Mass Assignment
  it { should allow_mass_assignment_of(:email) }

  # Associations
  it { should belong_to(:workshop) }

  # Validations
  it { should_not allow_value(nil).for(:email) }
  it { should_not allow_value(' ').for(:email) }
  it { should_not allow_value('foo').for(:email) }
  it { should allow_value('foo@example.com').for(:email) }

  describe '#notify' do
    it 'enqueues SendFollowUpEmailJob' do
      SendFollowUpEmailJob.stubs :enqueue
      follow_up = build(:follow_up)
      section = build(:section)
      follow_up.notify section
      SendFollowUpEmailJob.should have_received(:enqueue).
        with(follow_up.id, section.id)
    end
  end
end
