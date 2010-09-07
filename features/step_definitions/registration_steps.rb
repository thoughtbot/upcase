Then '$email is registered for the $course_name course' do |email,course_name|
  user = User.find_by_email!(email)
  course = Course.find_by_name!(course_name)
  section = user.sections.detect {|s| s.course == course}
  section.should_not be_nil, "expected #{email} to be registered for #{course_name}"
end
