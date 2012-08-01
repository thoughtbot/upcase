Then 'I see the empty section description' do
  page.should have_content('No courses are running at this time')
end

When 'I follow the external registration link' do
  url = find("*[@id='register-button']")[:href]
  url.should_not be_nil, "cannot find the external registration link"

  Misc.rails_app = Capybara.app
  Capybara.app = Sinatra::Application
  visit url
end


Then /^I should not see the external registration link$/ do
  page.should have_no_css("#register-button")
end

Then /^I should a registration link to be notified$/ do
  page.should have_css("#register-button[href='#new_follow_up']", text: "Get notified")
end

Then 'I see the section from "$start_date" to "$end_date"' do |start_date, end_date|
  section = section(start_date, end_date)
  course = section.course
  date_string = course_date_string(start_date, end_date)
  within("#course_#{course.id}") do
    page.should have_content(date_string)
  end
end

Then 'I see the home page section from "$start_date" to "$end_date"' do |start_date, end_date|
  section = section(start_date, end_date)
  course = section.course
  date_string = course_date_string(start_date, end_date)
  within("#section_#{section.id}") do
    page.should have_content(date_string)
  end
end

Then 'I do not see the home page section from "$start_date" to "$end_date"' do |start_date, end_date|
  section = section(start_date, end_date)
  course = section.course
  date_string = course_date_string(start_date, end_date)
  page.should_not have_css("#section_#{section.id}:contains('#{date_string}')")
end

Then 'I see that "$teacher_name" is teaching' do |teacher_name|
  find_field(teacher_name)['checked'].should be
end

Then 'I do not see that "$teacher_name" is teaching' do |teacher_name|
  find_field(teacher_name)['checked'].should_not be
end

Then "I see that the section teacher can't be blank" do
  page.should have_content("must specify at least one teacher")
end

Then '"$teacher_name" has a Gravatar for "$teacher_email"' do |teacher_name, teacher_email|
  gravatar_hash = Digest::MD5.hexdigest(teacher_email.strip.downcase)
  teacher = Teacher.find_by_email!(teacher_email)
  page.should have_css(%{img[src="https://secure.gravatar.com/avatar/#{gravatar_hash}?s=20"]})
end

Then 'I see the user "$user_name" in the list of users' do |user_name|
  within('#student-list ul') do
    page.should have_content(user_name)
  end
end

Then 'I see the section location is "$location"' do |location|
  page.should have_css(".address", text: location)
end

Then %{I see the section location's name is "$location_name"} do |location_name|
  within("#location") do
    page.should have_content(location_name)
  end
end

Then 'I see the section date is "$section_date_range"' do |section_date_range|
  within("#register-date") do
    page.should have_content(section_date_range)
  end
end

Then 'I see the section time is "$section_time_range"' do |section_time_range|
  within("#register-time") do
    page.should have_content(section_time_range)
  end
end

Then 'I see the section price is "$price"' do |price|
  within("#amount") do
    page.should have_content(price)
  end
end

Then 'I see that one of the teachers is "$teacher_name"' do |teacher_name|
  page.should have_css(".teachers", text: teacher_name)
end

Then %{I see "$teacher_name"'s avatar} do |teacher_name|
  teacher = Teacher.find_by_name!(teacher_name)
  page.should have_css("img[src^='https://secure.gravatar.com/avatar/#{teacher.gravatar_hash}']")
end

When /^I should see "([^"]*)" before "([^"]*)"$/ do |section1_name, section2_name|
  page.body.should =~ /#{section1_name}.*#{section2_name}/m
end

When /^I follow the delete link to the section from "([^"]*)" to "([^"]*)"$/ do |start_date, end_date|
  section = section(start_date, end_date)
  inside section do
    click_link "Delete"
  end
end

Then /^I should not see the section from "([^"]*)" to "([^"]*)"$/ do |start_date, end_date|
  date_string = course_date_string(start_date, end_date)
  page.should have_no_css(".section", text: date_string)
end

When /^I follow the link to the section from "([^"]*)" to "([^"]*)"$/ do |starts_on, ends_on|
  section = Section.find_by_starts_on_and_ends_on!(Date.parse(starts_on), Date.parse(ends_on))
  find("a:contains('#{section.date_range}')").click
end

Then 'I see that "$student_name" has paid' do |student_name|
  within('ul#paid') do
    page.should have_content(student_name)
  end
end

Then 'I see that "$student_name" has not paid' do |student_name|
  within('ul#unpaid') do
    page.should have_content(student_name)
  end
end
