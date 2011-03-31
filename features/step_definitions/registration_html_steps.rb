Then 'I see the course registration page for "$course_name"' do |course_name|
  page.should have_content(course_name)
  page.should have_content("Register")
end
