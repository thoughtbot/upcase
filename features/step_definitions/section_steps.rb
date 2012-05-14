Given '"$teacher_name" is teaching the section from "$section_start" to "$section_end"' do |teacher_name, section_start, section_end|
  start_date = Date.parse(section_start)
  end_date = Date.parse(section_end)
  section = Section.find_by_starts_on_and_ends_on!(start_date, end_date)
  teacher = Teacher.find_by_name!(teacher_name)
  create(:section_teacher, :section => section, :teacher => teacher)
end

Given 'I create the following section for "$course_name":' do |course_name, section_data|
  steps %{
    Given a teacher exists with a name of "Albert Einstein"
    When I go to the admin page
    And I follow "New Section" within the course "#{course_name}"
    When I select the start date of "June 14, 2010"
  }
  step "I fill in the following:", section_data
  steps %{
    And I select the teacher "Albert Einstein"
    And I press "Save Section"
    Then I see the successful section creation notice
  }
end

Given /^I am signed up as student of "([^"]*)" on ([0-9-]+)$/ do |course_name, date|
  course = create(:course, name: course_name)
  section = create(:section, course: course, starts_on: date)
  @registration = create(:paid_registration, section: section)
end

When /^it is a week before ([0-9-]+)$/ do |date|
  Timecop.freeze(DateTime.parse(date) - 1.week)
end
