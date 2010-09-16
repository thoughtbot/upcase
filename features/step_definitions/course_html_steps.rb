Then 'I see the course resource page for "$course_name"' do |course_name|
  page.should have_content(course_name)
  page.should have_content('Resources')
end

Then 'I see the admin listing include a course named "$course_name"' do |course_name|
  page.should have_content(course_name)
end

Then 'I see the course named "$course_name"' do |course_name|
  course = Course.find_by_name!(course_name)
  page.should have_css("##{dom_id(course)}")
end

World(ActionController::RecordIdentifier)

