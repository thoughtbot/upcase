Then 'I see the admin listing include a course named "$course_name"' do |course_name|
  page.should have_content(course_name)
end

Then 'I see the course named "$course_name"' do |course_name|
  course = Course.find_by_name!(course_name)
  page.should have_css("##{dom_id(course)}")
end

Then 'I should not see the course named "$course_name"' do |course_name|
  course = Course.find_by_name!(course_name)
  page.should_not have_css("##{dom_id(course)}.workshops")
end

When 'I fill in the required course fields' do
  steps %{
    When I fill in the course name with "Test-Driven Haskell"
    And I fill in the course description with "Learn Haskell the thoughtbot way"
    And I fill in the short description with "Learn Haskell the thoughtbot way"
    And I fill in the course price with "1900"
    And I fill in the start time with "09:00"
    And I fill in the end time with "17:00"
  }
end

When 'I fill in the following questions:' do |question_table|
  question_table.hashes.each_with_index do |question_hash, index|
    number = index + 1
    steps %{
      When I fill in the question #{number} field with "#{question_hash['question']}"
      And I fill in the answer #{number} field with "#{question_hash['answer']}"
    }
  end
end

When 'I fill in the following follow ups:' do |follow_up_table|
  follow_up_table.hashes.each_with_index do |follow_up_hash, index|
    number = index + 1
    steps %{
      When I fill in the follow up #{number} field with "#{follow_up_hash['email']}"
    }
  end
end

Then 'I see the following questions:' do |question_table|
  question_table.hashes.each_with_index do |question_hash, index|
    number = index + 1
    steps %{
      Then the question #{number} field should contain "#{question_hash['question']}"
      And the answer #{number} field should contain "#{question_hash['answer']}"
    }
  end
end

Then 'I see the question "$question"' do |question|
  within("#faq") do
    page.should have_content(question)
  end
end

Then 'I see the answer "$answer"'do |answer|
  within("#faq") do
    page.should have_content(answer)
  end
end

When /^I drag the course "([^"]*)" before "([^"]*)"$/ do |first_name, second_name|
  first_course = Course.find_by_name!(first_name)
  second_course = Course.find_by_name!(second_name)
  first_course_dom = "#course_#{first_course.id}"
  second_course_dom = "#course_#{second_course.id}"
  page.execute_script <<-JS
    $("#{first_course_dom}").insertBefore($("#{second_course_dom}"))
    $("#course_list").trigger('sortupdate', [{item: $('#{first_course_dom}')}]);
  JS

end

Then /^I see "([^"]*)" is scheduled from "([^"]*)" to "([^"]*)"$/ do |course_name, start_date, end_date|
  course = Course.find_by_name!(course_name)
  date_string = course_date_string(start_date, end_date)
  within "##{dom_id(course)}" do
    page.should have_content(date_string)
  end
end

Then /^I should see the following courses in order:$/ do |table|
  course_titles = table.raw.join(".*")
  regexp = Regexp.new(course_titles, Regexp::MULTILINE)
  page.body.should =~ regexp
end

World(ActionController::RecordIdentifier)
