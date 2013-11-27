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
  it { should validate_presence_of :start_at }
  it { should validate_presence_of :starts_on }
  it { should validate_presence_of :stop_at }

  describe '.active' do
    it "includes sections thats haven't started" do
      active = create(:section, starts_on: 1.day.from_now, ends_on: 7.days.from_now)
      create(:section, starts_on: 1.week.ago, ends_on: 7.days.from_now)
      active2 = create(:section, starts_on: Time.zone.today, ends_on: 7.days.from_now)
      expect(Section.active).to eq [active2, active]
    end

    it "includes sections that don't end" do
      active = create(:section, starts_on: 1.week.ago, ends_on: nil)

      expect(Section.active).to eq [active]
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

  describe '#full?' do
    context 'when seats_available and maximum_students is not set' do
      it 'returns false no matter how many registrations there are' do
        workshop = create(:workshop, maximum_students: nil)
        section = create(:section, workshop: workshop, seats_available: nil)

        section.stubs(purchases: stub(count: 0))

        section.should_not be_full

        section.stubs(purchases: stub(count: 300))

        section.should_not be_full
      end
    end

    context 'when there are a limited number of seats' do
      it 'returns true if all the seats are taken' do
        workshop = create(:workshop, maximum_students: 8)
        section = create(:section, workshop: workshop)

        section.stubs(purchases: stub(count: 8))

        section.should be_full
      end

      it 'returns false if all the seats are not taken' do
        workshop = create(:workshop, maximum_students: 8)
        section = create(:section, workshop: workshop)

        section.stubs(purchases: stub(count: 2))

        section.should_not be_full
      end
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

  describe '.upcoming?' do
    it 'knows if it has happened yet' do
      next_week = Section.new(starts_on: 1.week.from_now)
      last_week = Section.new(starts_on: 1.week.ago)
      today = Section.new(starts_on: Time.zone.today)
      expect(today).to be_upcoming
      expect(next_week).to be_upcoming
      expect(last_week).not_to be_upcoming
    end
  end

  context '.by_starts_on_desc' do
    it 'returns sections newest to oldest by starts_on' do
      old_section = create(:section, starts_on: 2.weeks.from_now)
      new_section = create(:section, starts_on: 4.weeks.from_now)

      Section.by_starts_on_desc.should == [new_section, old_section]
    end
  end

  describe '.in_active_workshop' do
    it 'returns sections which are in active workshop' do
      active_workshop = create(:workshop, active: true)
      section = create(:section, workshop: active_workshop)

      expect(Section.in_active_workshop).to include(section)
    end

    it 'does not returns sections if workshops are not active' do
      inactive_workshop = create(:workshop, active: false)
      section = create(:section, workshop: inactive_workshop)

      expect(Section.in_active_workshop).not_to include(section)
    end
  end

  describe '#subscription?' do
    it 'returns false' do
      expect(Section.new).not_to be_subscription
    end
  end

  describe 'purchase_for' do
    it 'returns the purchase when a user has purchased a section' do
      user = create(:user)
      purchase = create_subscriber_purchase(:online_section, user)
      section = purchase.purchaseable

      expect(section.purchase_for(user)).to eq purchase
    end

    it 'returns nil when a user has not purchased a product' do
      user = create(:user)
      purchase = create_subscriber_purchase(:online_section)
      section = purchase.purchaseable

      expect(section.purchase_for(user)).to be_nil
    end
  end

  describe '.current' do
    it "does not include sections that haven't started or have finished" do
      past = create(:past_section)
      future = create(:future_section)
      current = create(:section, starts_on: Time.zone.today, ends_on: 1.day.from_now)

      expect(Section.current).to include current
      expect(Section.current).not_to include future
      expect(Section.current).not_to include past
      Timecop.freeze(1.day.from_now) do
        expect(Section.current).to include current
      end
      Timecop.freeze(Time.zone.today + 3) do
        expect(Section.current).not_to include current
      end
    end

    it 'includes sections with no end date that have started' do
      past = create(:past_section)
      future = create(:future_section, ends_on: nil)
      current = create(:section, starts_on: Time.zone.today, ends_on: nil)

      expect(Section.current).to include current
      expect(Section.current).not_to include future
      expect(Section.current).not_to include past
      Timecop.freeze(1.day.from_now) do
        expect(Section.current).to include current
      end
      Timecop.freeze(Time.zone.today + 3) do
        expect(Section.current).to include current
      end
    end
  end

  describe '.send_office_hours_reminders' do
    it 'sends an office hour reminder for each current section' do
      workshop = create(:workshop)
      future = create(:future_section, workshop: workshop)
      current = create(
        :section,
        workshop: workshop,
        starts_on: Time.zone.today,
        ends_on: 1.day.from_now
      )
      email = stub(deliver: nil)
      WorkshopMailer.stubs(office_hours_reminder: email)
      future_purchase = create_subscriber_purchase_from_purchaseable(future)
      current_purchase = create_subscriber_purchase_from_purchaseable(current)

      Section.send_office_hours_reminders

      expect(WorkshopMailer).to have_received(:office_hours_reminder).
        with(current, current_purchase.email)
      expect(email).to have_received(:deliver)
      expect(WorkshopMailer).to have_received(:office_hours_reminder).
        with(future, future_purchase.email).never
    end
  end

  describe '.send_surveys' do
    it 'sends a survey to students who finish a workshop today' do
      workshop = create(:workshop, length_in_days: 2)
      future = create(:future_section, workshop: workshop)
      ongoing = create(
        :section,
        workshop: workshop,
        starts_on: Time.zone.today,
        ends_on: nil
      )
      future_purchase = create_subscriber_purchase_from_purchaseable(future)
      current_purchase = create_subscriber_purchase_from_purchaseable(ongoing)
      Timecop.travel(1.day.from_now) do
        @next_purchase = create_subscriber_purchase_from_purchaseable(ongoing)
      end

      should_not_send_a_survey_to([
        current_purchase,
        future_purchase,
        @next_purchase
      ])

      Timecop.freeze(2.days.from_now) do
        should_send_a_survey_to([current_purchase])
        should_not_send_a_survey_to([
          future_purchase,
          @next_purchase
        ])
      end

      Timecop.freeze(3.days.from_now) do
        should_send_a_survey_to([@next_purchase])
        should_not_send_a_survey_to([
          future_purchase,
          current_purchase
        ])
      end
    end

    def should_send_a_survey_to(purchases)
      clear_deliveries_and_send_surveys

      purchases.each do |purchase|
        check_for_survey_email(purchase).should eq true
      end
    end

    def should_not_send_a_survey_to(purchases)
      clear_deliveries_and_send_surveys

      purchases.each do |purchase|
        check_for_survey_email(purchase).should eq false
      end
    end

    def clear_deliveries_and_send_surveys
      ActionMailer::Base.deliveries.clear
      Section.send_surveys
    end

    def check_for_survey_email(purchase)
      ActionMailer::Base.deliveries.any? do |email|
        email.to == [purchase.email] && email.subject =~ /how we did/i
      end
    end
  end

  describe 'starts_on' do
    it 'returns the given date for a section with no end date' do
      section = build(:online_section, starts_on: 1.year.ago, ends_on: nil)

      expect(section.starts_on(Time.zone.today)).to eq Time.zone.today
    end

    it 'returns starts_on for a section with an end date' do
      starts_on = 7.days.from_now.to_date
      section = build(:in_person_section, starts_on: starts_on, ends_on: 4.weeks.from_now)

      expect(section.starts_on(Time.zone.today)).to eq starts_on
    end
  end

  describe 'ends_on' do
    it 'returns the date equal to the registration date plus the length of the workshop for a section with no end date' do
      section = create(:online_section, starts_on: 1.year.ago, ends_on: nil)
      section.workshop.length_in_days = 28
      section.workshop.save!

      expect(section.ends_on(Time.zone.today)).to eq (Time.zone.today + 28.days)
    end

    it 'returns the end_date for a section with an end date' do
      ends_on = 14.days.from_now.to_date
      section = build(:in_person_section, starts_on: 7.days.from_now, ends_on: ends_on)

      expect(section.ends_on(Time.zone.today)).to eq ends_on
    end
  end

  describe '#starts_immediately?' do
    it 'does not start immediately when the section has an end date' do
      section = create(
        :section,
        starts_on: Time.zone.today,
        ends_on: 1.day.from_now
      )

      expect(section.starts_immediately?).to be false
    end

    it 'starts immediately when the section does not have an end date' do
      section = create(
        :section,
        starts_on: Time.zone.today,
        ends_on: nil
      )

      expect(section.starts_immediately?).to be true
    end
  end
end
