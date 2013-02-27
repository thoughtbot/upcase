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

  describe 'self.active' do
    it "only includes sections thats haven't started" do
      active = create(:section, starts_on: Date.tomorrow, ends_on: 7.days.from_now)
      create(:section, starts_on: 1.week.ago, ends_on: 7.days.from_now)
      active2 = create(:section, starts_on: Date.today, ends_on: 7.days.from_now)
      expect(Section.active).to eq [active2, active]
    end
  end

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

  describe '.upcoming?' do
    it 'knows if it has happened yet' do
      next_week = Section.new(starts_on: 1.week.from_now)
      last_week = Section.new(starts_on: 1.week.ago)
      today = Section.new(starts_on: Date.today)
      expect(today).to be_upcoming
      expect(next_week).to be_upcoming
      expect(last_week).not_to be_upcoming
    end
  end

  describe '#fulfillment_method' do
    it 'returns in-person if the workshop is an in-person one' do
      in_person_workshop = create(:workshop, online: false)
      section = create(:section, workshop: in_person_workshop)

      expect(section.fulfillment_method).to eq('in-person')
    end

    it 'returns online if the workshop is an online one' do
      online_workshop = create(:workshop, online: true)
      section = create(:section, workshop: online_workshop)

      expect(section.fulfillment_method).to eq('online')
    end
  end
end

describe Section do
  context 'self.by_starts_on_desc' do
    it 'returns sections newest to oldest by starts_on' do
      old_section = create(:section, starts_on: 2.weeks.from_now)
      new_section = create(:section, starts_on: 4.weeks.from_now)

      Section.by_starts_on_desc.should == [new_section, old_section]
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
      purchase = create(:online_section_purchase, user: user)
      section = purchase.purchaseable

      expect(section.purchase_for(user)).to eq purchase
    end

    it 'returns nil when a user has not purchased a product' do
      user = create(:user)
      purchase = create(:online_section_purchase)
      section = purchase.purchaseable

      expect(section.purchase_for(user)).to be_nil
    end
  end

  describe '.current' do
    it "does not include sections that haven't started or have finished" do
      past = create(:past_section)
      future = create(:future_section)
      current = create(:section, starts_on: Date.today, ends_on: Date.tomorrow)

      expect(Section.current).to include current
      expect(Section.current).not_to include future
      expect(Section.current).not_to include past
      Timecop.freeze(Date.tomorrow) do
        expect(Section.current).to include current
      end
      Timecop.freeze(Date.today + 2) do
        expect(Section.current).not_to include current
      end
    end
  end

  describe '.send_notifications' do
    it 'sends notifications for each current section' do
      notifier = stub(send_notifications_for: nil)
      Notifier.stubs(new: notifier)

      future = create(:future_section)
      workshop = future.workshop
      current = create(:section, workshop: workshop, starts_on: Date.today, ends_on: Date.tomorrow)

      future_purchase = create(:paid_purchase, purchaseable: future)
      current_purchase = create(:paid_purchase, purchaseable: current)

      video = create(:video, watchable: workshop)
      event = create(:event, workshop: workshop)

      Section.send_notifications

      expect(Notifier).to have_received(:new).with(current, [current_purchase.email])
      expect(notifier).to have_received(:send_notifications_for).with([video])
      expect(notifier).to have_received(:send_notifications_for).with([event])

      expect(Notifier).to have_received(:new).with(future, [future_purchase.email]).never
    end
  end
end
