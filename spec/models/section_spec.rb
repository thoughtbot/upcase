require 'spec_helper'

describe Section do
  # Associations
  it { should belong_to(:workshop) }
  it { should have_many(:paid_purchases) }
  it { should have_many(:purchases) }
  it { should have_many(:section_teachers) }
  it { should have_many(:unpaid_purchases) }
  it { should have_many(:teachers).through(:section_teachers) }

  # Validations
  it { should validate_presence_of :address }
  it { should validate_presence_of :ends_on }
  it { should validate_presence_of :start_at }
  it { should validate_presence_of :starts_on }
  it { should validate_presence_of :stop_at }

  describe '#date_range' do
    context 'when starts_on and ends_on are nil' do
      it 'returns nil' do
        section = Section.new
        section.date_range.should be_nil
      end
    end

    context 'when starts_on == ends_on' do
      it 'returns a string representation of a single date' do
        date = '20121102'
        section = create(:section, starts_on: date, ends_on: date)
        section.date_range.should eq('November 02, 2012')
      end
    end

    context 'when starts_on and ends_on are different years' do
      it 'includes month and year in both dates' do
        section = create(:section, starts_on: '20121102', ends_on: '20131102')
        section.date_range.should eq('November 02, 2012-November 02, 2013')
      end
    end

    context 'when starts_on and ends_on are different months' do
      it 'does not repeat the year' do
        section = create(:section, starts_on: '20121102', ends_on: '20121202')
        section.date_range.should eq('November 02-December 02, 2012')
      end
    end

    context 'when starts_on and ends_on are different days' do
      it 'does not repeat the month or year' do
        section = create(:section, starts_on: '20121102', ends_on: '20121103')
        section.date_range.should eq('November 02-03, 2012')
      end
    end
  end

  describe '#seats_available' do
    let(:workshop) do
      create :workshop, maximum_students: 8
    end

    context 'when seats_available is not set' do
      it 'returns workshop.maximum_students' do
        section = create(:section, workshop: workshop)
        section.seats_available.should eq(8)
      end
    end

    context 'when seats_available is set' do
      it 'returns seats_available' do
        section = create(:section, workshop: workshop, seats_available: 12)
        section.seats_available.should eq(12)
      end
    end
  end

  describe '#send_reminders' do
    it 'sends reminder emails to all paid registrants' do
      section = create(:section)
      create :purchase, purchaseable: section, paid: true
      create :purchase, purchaseable: section, paid: true
      create :purchase, purchaseable: section, paid: false, payment_method: 'paypal'
      create :purchase, paid: true
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
        create :paid_purchase, purchaseable: section
      end

      ActionMailer::Base.deliveries.clear
      Section.send_reminders
      ActionMailer::Base.deliveries.should have(1).email
    end
  end

  describe '#to_param' do
    it 'returns the id and parameterized workshop name' do
      section = create(:section)
      expected = "#{section.id}-#{section.name.parameterize}"
      section.to_param.should eq(expected)
    end
  end

  describe '.unique_section_teachers_by_teacher' do
    it 'returns 1 section_teacher per teacher' do
      section_teacher_one = create(:section).section_teachers.first
      section_teacher_two = create(:section).section_teachers.first
      create(:section).teachers = [section_teacher_two.teacher]
      expected = [section_teacher_one, section_teacher_two]
      Section.unique_section_teachers_by_teacher.should eq(expected)
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

  describe '#active?' do
    it 'returns true if the section is active' do
      active_section = create(:section, ends_on: 1.week.from_now)

      active_section.should be_active
    end

    it 'returns false if the section is inactive but there is another active section' do
      active_section = create(:section, ends_on: 1.week.from_now)
      inactive_section = create(:section, ends_on: 1.day.ago)

      inactive_section.should_not be_active
    end
  end

  describe '#fulfillment_method' do
    it 'returns in-person if the workshop is an in-person one' do
      in_person_workshop = create(:workshop, online: false)
      section = create(:section, workshop: in_person_workshop)

      section.fulfillment_method.should eq('in-person')
    end

    it 'returns online if the workshop is an online one' do
      online_workshop = create(:workshop, online: true)
      section = create(:section, workshop: online_workshop)

      section.fulfillment_method.should eq('online')
    end
  end
end

describe Section, 'self.by_starts_on_desc' do
  it 'returns sections newest to oldest by starts_on' do
    old_section = create(:section, starts_on: 2.weeks.from_now)
    new_section = create(:section, starts_on: 4.weeks.from_now)

    Section.by_starts_on_desc.should == [new_section, old_section]
  end
end
