require 'spec_helper'

feature 'Visitor views upcoming workshop details' do
  scenario 'views workshop FAQs' do
    workshop = create(:workshop)
    workshop_page = PageObjects::Workshop.new(workshop)
    create(:question, workshop: workshop, question: 'What color?', answer: 'Blue')
    create(:question, workshop: workshop, question: 'Pets allowed?', answer: 'No')

    workshop_page.load

    expect(workshop_page).to have_questions('What color?', 'Pets allowed?')
    expect(workshop_page).to have_answers('Blue', 'No')
  end

  scenario 'sees no FAQ if it does not exist' do
    workshop = create(:workshop)
    workshop_page = PageObjects::Workshop.new(workshop)

    workshop_page.load

    expect(workshop_page).to have(0).questions
    expect(workshop_page).to have(0).answers
  end

  scenario 'for an upcoming section' do
    section_attributes = {
      teacher: 'ralph',
      starts_on: jun_13,
      ends_on: jun_16,
      start_at: '9:00',
      stop_at: '17:00',
      address: '41 Winter St',
      city: 'Boston',
      state: 'MA',
      zip: '02108'
    }

    workshop_page = create_workshop_and_section_with(section_attributes)

    Timecop.freeze(jun_10) do
      workshop_page.load

      expect(workshop_page).to be_located_in('Boston')
      expect(workshop_page).to be_held_at('9:00AM-5:00PM')
      expect(workshop_page).to have_dates('June 13-16, 2013')
      expect(workshop_page).to be_taught_by('ralph')
      expect(workshop_page).to have_an_avatar_for('ralph')
    end
  end

  scenario 'with multiple sections' do
    section_attributes = {
      teacher: 'ralph',
      starts_on: jun_13,
      ends_on: jun_16,
      city: 'Boston',
      state: 'MA',
      zip: '02108'
    }
    section2_attributes = {
      teacher: 'joe',
      starts_on: jun_20,
      ends_on: jun_22,
      city: 'San Francisco',
      state: 'CA',
      zip: '94105'
    }

    workshop_page = create_workshop_and_section_with(section_attributes)
    create_section_with(workshop_page.workshop, section2_attributes)

    Timecop.freeze(jun_10) do
      workshop_page.load

      expect(workshop_page).to be_located_in('Boston')
      expect(workshop_page).to be_held_at('9:00AM-5:00PM')
      expect(workshop_page).to have_dates('June 13-16, 2013')
      expect(workshop_page).to be_taught_by('ralph')
      expect(workshop_page).to have_an_avatar_for('ralph')

      expect(workshop_page).to have_dates('June 20-22, 2013')
      expect(workshop_page).to be_taught_by('joe')
      expect(workshop_page).to have_an_avatar_for('joe')
    end
  end

  scenario 'with multiple sections taught by the same person' do
    section_attributes = {
      teacher: 'ralph',
      starts_on: jun_13,
      ends_on: jun_16
    }
    section2_attributes = {
      teacher: 'ralph',
      starts_on: jun_20,
      ends_on: jun_22
    }

    workshop_page = create_workshop_and_section_with(section_attributes)
    create_section_with(workshop_page.workshop, section2_attributes)

    Timecop.freeze(jun_10) do
      workshop_page.load

      expect(workshop_page).to be_only_taught_by('ralph')
      expect(workshop_page).to have_an_avatar_for('ralph')
    end
  end

  scenario 'for an online workshop' do
    section_attributes = {
      teacher: 'ralph',
      starts_on: jun_13,
      ends_on: jun_16
    }

    workshop_page = create_workshop_and_section_with(section_attributes)

    Timecop.freeze(jun_10) do
      workshop_page.load

      expect(workshop_page).not_to have_date_range
    end
  end

  scenario 'for an online workshop with no sections' do
    workshop = create(:online_workshop)
    workshop_page = PageObjects::Workshop.new(workshop)

    workshop_page.load

    expect(workshop_page).not_to have_date_range
  end

  def create_workshop_and_section_with(attributes)
    workshop = create(:workshop)
    create_section_with(workshop, attributes)

    PageObjects::Workshop.new(workshop)
  end

  def create_online_workshop_and_section_with(attributes)
    workshop = create(:online_workshop)
    create_section_with(workshop, attributes)

    PageObjects::Workshop.new(workshop)
  end

  def create_section_with(workshop, attributes)
    teacher_name = attributes.delete(:teacher)
    teacher = find_or_create_teacher(teacher_name)
    attributes.merge!(teachers: [teacher], workshop: workshop)
    create(:section, attributes)
  end

  def find_or_create_teacher(name)
    Teacher.where(name: name).first || create(:teacher, name: name)
  end

  def jun_10
    Date.parse('June 10, 2013')
  end

  def jun_13
    Date.parse('June 13, 2013')
  end

  def jun_16
    Date.parse('June 16, 2013')
  end

  def jun_20
    Date.parse('June 20, 2013')
  end

  def jun_22
    Date.parse('June 22, 2013')
  end
end
