Then 'I see the empty section description' do
  page.should have_content('No courses are running at this time')
end

When 'I follow the external registration link' do
  url = find("*[@id='registration-link']")[:href]
  url.should_not be_nil, "cannot find the external registration link"

  Misc.rails_app = Capybara.app
  Capybara.app = Sinatra::Application
  visit url
end

Then 'I see the section from "$start_date" to "$end_date"' do |start_date_string, end_date_string|
  start_date = Date.parse(start_date_string)
  end_date = Date.parse(end_date_string)
  section = Section.find_by_starts_on_and_ends_on!(start_date, end_date)
  course = section.course
  date_string = "#{Date::MONTHNAMES[start_date.month]} #{start_date.day}-#{end_date.day}, #{start_date.year}"
  within("#course_#{course.id}") do
    page.should have_content(date_string)
  end
end

Then 'I see that "$teacher_name" is teaching' do |teacher_name|
  find_field(teacher_name).node.attributes['checked'].value.should == 'checked'
end

Then "I see that the section teacher can't be blank" do
  page.should have_content("must specify at least one teacher")
end

Then '"$teacher_name" has a Gravatar for "$teacher_email"' do |teacher_name, teacher_email|
  gravatar_hash = Digest::MD5.hexdigest(teacher_email.strip.downcase)
  teacher = Teacher.find_by_email!(teacher_email)
  page.should have_css(%{img[src="http://www.gravatar.com/avatar/#{gravatar_hash}?s=20"]})
end

Then 'I see the user "$user_name" in the list of users' do |user_name|
  within('#student-list ul') do
    page.should have_content(user_name)
  end
end

Then 'I see the section location is "$location"' do |location|
  within("#section-location") do
    page.should have_content(location)
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

Then 'I see the section terms of service is "$terms_of_service"' do |terms_of_service|
  within("#terms") do
    page.should have_content(terms_of_service)
  end
end

Then 'I see that one of the teachers is "$teacher_name"' do |teacher_name|
  within('#teachers') do
    page.should have_content(teacher_name)
  end
end

Then %{I see "$teacher_name"'s avatar} do |teacher_name|
  teacher = Teacher.find_by_name!(teacher_name)
  page.should have_css("img[alt='#{teacher.image_name}']")
end
