Given 'I create the following workshop:' do |workshop_fields|
  steps %{
    Given I go to the admin page
    And I follow "New Workshop"
  }
  And "I fill in the following:", workshop_fields
  steps %{
    And I press "Create Workshop"
    Then I see the successful workshop creation notice
  }
end

Then /^I should see the json for the public workshops$/ do
  workshops = Workshop.only_public
  JSON.parse(page.source).should == JSON.parse(workshops_json(workshops))
end

Then /^I should see the json for the public workshops with the callback "([^"]*)"$/ do |callback|
  workshops = Workshop.only_public
  matcher = /#{callback}\(([^\)]+)\)/
  matches = matcher.match(page.source)
  JSON.parse(matches[1]).should == JSON.parse(workshops_json(workshops))
end

Given /^a non-public workshop "([^"]*)"$/ do |workshop_name|
  workshop = Workshop.find_by_name!(workshop_name)
  workshop.public = false
  workshop.save!
end

When /^I attach an image name "([^"]*)" to the workshop$/ do |image_name|
  path = File.join(Rails.root, "tmp/", image_name)
  test_image_path = File.join(Rails.root,"features/support/files/test.jpg")
  FileUtils.mkdir_p(Rails.root.join("tmp"))
  FileUtils.cp(test_image_path, path)
  attach_file "Workshop image", path
end

Then /^I should see that "([^"]*)" is an online workshop$/ do |workshop_name|
  find('[data-role=online-workshops]').should have_content workshop_name
end

Then /^I should see that "([^"]*)" is an in-person workshop$/ do |workshop_name|
  find('[data-role=in-person-workshops]').should have_content workshop_name
end

World(WorkshopsHelper)
