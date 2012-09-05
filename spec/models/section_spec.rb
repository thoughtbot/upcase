require 'spec_helper'

describe Section do
  it { should validate_presence_of :start_at }
  it { should validate_presence_of :stop_at }
  it { should validate_presence_of :address }

  context "#to_param" do
    subject { create(:section) }
    it "returns the id and parameterized course name" do
      subject.to_param.should == "#{subject.id}-#{subject.course_name.parameterize}"
    end
  end

  context "#seats_available" do
    let(:course) { create(:course, maximum_students: 8) }
    context "with no seats available set" do
      subject { create(:section, course: course) }
      it "returns course's maximum students" do
        subject.seats_available.should == 8
      end
    end

    context "with seats available set" do
      subject { create(:section, course: course, seats_available: 12) }
      it "returns section's seats available" do
        subject.seats_available.should == 12
      end
    end
  end
end

describe Section, 'upcoming sections' do
  it 'knows which sections are a week away' do
    expected = create(:section, starts_on: 1.week.from_now)
    create(:section, starts_on: 1.week.from_now + 1.day)
    create(:section, starts_on: 1.week.from_now - 1.day)

    upcoming = Section.upcoming

    upcoming.should == [expected]
  end
end

describe Section, 'sending reminders' do
  it 'only sends reminders for a week from today' do
    sections = [
      create(:section, starts_on: 1.week.from_now),
      create(:section, starts_on: 1.week.from_now + 1.day),
      create(:section, starts_on: 1.week.from_now - 1.day)
    ]
    sections.each { |section| create(:paid_registration, section: section) }
    ActionMailer::Base.deliveries.clear

    Section.send_reminders

    ActionMailer::Base.deliveries.should have(1).email
  end

  it 'sends reminder emails to all paid registrants' do
    section = create(:section)
    create(:registration, section: section, paid: true)
    create(:registration, section: section, paid: true)
    create(:registration, section: section, paid: false)
    create(:registration, paid: true)
    ActionMailer::Base.deliveries.clear

    section.send_reminders

    ActionMailer::Base.deliveries.should have(2).email
  end
end

describe Section, 'teacher uniqueness' do
  before do
    @section1 = build(:section_without_teacher)
    @section2 = build(:section_without_teacher)

    @billy = create(:teacher, name: "Billy")
    @michael = create(:teacher, name: "Michael")
    @common = create(:teacher, name: "Common")
  end

  it 'is considered to have different teachers if none of the teachers is shared' do
    @section1.teachers << [@billy, @common]
    @section2.teachers << [@michael, @common]

    @section1.save!
    @section2.save!

    Section.should have_different_teachers
  end

  it 'is considered to have same teachers if all teachers are the same' do
    @section1.teachers << [@common, @michael]
    @section2.teachers << [@michael, @common]

    @section1.save!
    @section2.save!

    Section.should_not have_different_teachers
  end
end
