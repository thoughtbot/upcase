Then 'I see the admin listing include a workshop named "$workshop_name"' do |workshop_name|
  page.should have_content(workshop_name)
end

Then 'I see the workshop named "$workshop_name"' do |workshop_name|
  workshop = Workshop.find_by_name!(workshop_name)
  page.should have_css("##{dom_id(workshop)}")
end

Then 'I should not see the workshop named "$workshop_name"' do |workshop_name|
  workshop = Workshop.find_by_name!(workshop_name)
  page.should_not have_css("##{dom_id(workshop)}.workshops")
end

When 'I fill in the required workshop fields' do
  steps %{
    When I fill in the workshop name with "Test-Driven Haskell"
    And I fill in the workshop description with "Learn Haskell the thoughtbot way"
    And I fill in the short description with "Learn Haskell the thoughtbot way"
    And I fill in the workshop price with "1900"
    And I fill in the workshop company price with "2000"
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

Then /^I see "([^"]*)" is scheduled from "([^"]*)" to "([^"]*)"$/ do |workshop_name, start_date, end_date|
  workshop = Workshop.find_by_name!(workshop_name)
  date_string = workshop_date_string(start_date, end_date)
  within "##{dom_id(workshop)}" do
    page.should have_content(date_string)
  end
end

Then /^I should see the following workshops in order:$/ do |table|
  workshop_titles = table.raw.join(".*")
  regexp = Regexp.new(workshop_titles, Regexp::MULTILINE)
  page.body.should =~ regexp
end

World(ActionController::RecordIdentifier)
