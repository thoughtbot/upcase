Given '"$teacher_name" is teaching the section from "$section_start" to "$section_end"' do |teacher_name, section_start, section_end|
  start_date = Date.parse(section_start)
  end_date = Date.parse(section_end)
  section = Section.find_by_starts_on_and_ends_on!(start_date, end_date)
  teacher = Teacher.find_by_name!(teacher_name)
  section.teachers = [teacher]
end

Given /^the following sections? exists? for the workshop "([^"]*)":$/ do |workshop_name, section_data|
  workshop = Workshop.find_by_name!(workshop_name)
  section_data.hashes.each do |row|
    create(:section, row.merge(workshop: workshop))
  end
end

Given 'I create the following section for "$workshop_name":' do |workshop_name, section_data|
  steps %{
    Given a teacher exists with a name of "Albert Einstein"
    When I go to the admin page
    And I follow "New Section" within the workshop "#{workshop_name}"
    When I select the start date of "June 14, 2010"
  }
  step "I fill in the following:", section_data
  steps %{
    And I select the teacher "Albert Einstein"
    And I fill in the Boston address
    And I press "Save Section"
    Then I see the successful section creation notice
  }
end

Given /^I am signed up as student of "([^"]*)" on ([0-9-]+)$/ do |workshop_name, date|
  workshop = create(:workshop, name: workshop_name)
  section = create(:section, workshop: workshop, starts_on: date)
  @registration = create(:free_purchase, purchaseable: section)
end

When /^it is a week before ([0-9-]+)$/ do |date|
  Timecop.freeze(DateTime.parse(date) - 1.week)
end

When /^"([^"]*)" has registered and paid for the section on "([^"]*)"$/ do |name, starts_on|
  section = Section.find_by_starts_on!(Date.parse(starts_on))
  create(:paid_purchase, purchaseable: section, name: name)
end
