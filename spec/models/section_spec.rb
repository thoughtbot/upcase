require 'spec_helper'

describe Section do
  # Associations
  it { should belong_to(:course) }
  it { should have_many(:paid_registrations) }
  it { should have_many(:registrations) }
  it { should have_many(:section_teachers) }
  it { should have_many(:unpaid_registrations) }
  it { should have_many(:teachers).through(:section_teachers) }

  # Validations
  it { should validate_presence_of :address }
  it { should validate_presence_of :ends_on }
  it { should validate_presence_of :start_at }
  it { should validate_presence_of :starts_on }
  it { should validate_presence_of :stop_at }

  describe '#seats_available' do
    let(:course) do
      create :course, maximum_students: 8
    end

    context 'when seats_available is not set' do
      it 'returns course.maximum_students' do
        section = create(:section, course: course)
        section.seats_available.should eq(8)
      end
    end

    context 'when seats_available is set' do
      it 'returns seats_available' do
        section = create(:section, course: course, seats_available: 12)
        section.seats_available.should eq(12)
      end
    end
  end

  describe '#send_reminders' do
    it 'sends reminder emails to all paid registrants' do
      section = create(:section)
      create :registration, section: section, paid: true
      create :registration, section: section, paid: true
      create :registration, section: section, paid: false
      create :registration, paid: true
      ActionMailer::Base.deliveries.clear
      section.send_reminders
      ActionMailer::Base.deliveries.should have(2).email
    end
  end

  describe '.send_reminders' do
    it 'only sends reminders for a week from today' do
      sections = [
        create(:section, starts_on: 1.week.from_now),
        create(:section, starts_on: 1.week.from_now + 1.day),
        create(:section, starts_on: 1.week.from_now - 1.day)
      ]

      sections.each do |section|
        create :paid_registration, section: section
      end

      ActionMailer::Base.deliveries.clear
      Section.send_reminders
      ActionMailer::Base.deliveries.should have(1).email
    end
  end

  describe '#to_param' do
    it 'returns the id and parameterized course name' do
      section = create(:section)
      expected = "#{section.id}-#{section.course_name.parameterize}"
      section.to_param.should eq(expected)
    end
  end

  describe '.upcoming' do
    it 'knows which sections are a week away' do
      section = create(:section, starts_on: 1.week.from_now)
      create :section, starts_on: 1.week.from_now + 1.day
      create :section, starts_on: 1.week.from_now - 1.day
      Section.upcoming.should eq([section])
    end
  end
end
