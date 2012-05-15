module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /^the home\s?page$/
      '/'
    when /^the home page with the "([^"]+)" alternative for the "([^"]+)" experiment/
      "/?#{$2}=#{$1}"
    when 'the courses json page'
      courses_path(format: :json)
    when /the courses json page with the callback "([^"]+)"/
      courses_path(format: :json, callback: $1)
    when /the course page of "([^"]+)"/
      course_path(Course.find_by_name!($1))
    when /the section page of "([^"]+)"/
      section_path(Course.find_by_name!($1).active_section)
    when 'the sign up page'
      sign_up_path
    when 'the sign in page'
      sign_in_path
    when 'the password reset request page'
      new_password_path
    when 'the list of courses'
      admin_courses_path
    when 'the new teacher page'
      new_admin_teacher_path
    when 'the list of teachers page'
      admin_teachers_path
    when /^the new section page for "([^"]+)"$/
      course = Course.find_by_name!($1)
      new_admin_course_section_path(course)
    when /the page to add a new student to the section from "([^"]+)" to "([^"]+)"/
      section = Section.find_by_starts_on_and_ends_on!(Date.parse($1), Date.parse($2))
      new_admin_section_registration_path(section)
    when /the admin page/
      admin_path
    when /the freshbooks invoice page for "([^\"]+)" on "([^\"]+)"/
      course = Course.find_by_name!($2)
      registration = course.registrations.find_by_email($1)
      registration.freshbooks_invoice_url
    when /the URL "([^\"]+)"/
      $1
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end

  def link_to(link_description)
    case link_description
    when /the (.*) course/
      $1
    when 'register for a section'
      'register-button'
    when 'create a new course'
      'New Course'
    when /sign in/
      'Sign in'
    when /admin interface/
      'Admin'
    when /register/
      'Register'
    else
      raise %{Can't find a mapping from #{link_description.inspect} to a path: #{__FILE__}}
    end
  end

  def field_id_for(field_description)
    case field_description
    when 'audience name'
      'audience_name'
    when 'course name'
      'course_name'
    when 'course description'
      'course_description'
    when 'short description'
      'course_short_description'
    when 'course price'
      'course_price'
    when 'start time'
      'course_start_at'
    when 'end time'
      'course_stop_at'
    when 'section start time'
      'section_start_at'
    when 'section stop time'
      'section_stop_at'
    when 'location'
      'course_location'
    when 'location name'
      'course_location_name'
    when 'max students'
      'course_maximum_students'
    when 'reminder email text'
      'course_reminder_email'
    when 'course follow up email'
      'course_followup_email'
    when 'login email'
      'session_email'
    when 'login password'
      'session_password'
    when 'section start'
      'section_starts_on'
    when 'section end'
      'section_ends_on'
    when 'section teacher'
      'section_section_teachers_attributes_0_teacher_id'
    when 'seats available'
      'section_seats_available'
    when 'session email'
      'session_email'
    when 'session password'
      'session_password'
    when "teacher's name"
      'teacher_name'
    when "teacher's bio"
      'teacher_bio'
    when "teacher's email"
      'teacher_email'
    when "student's first name"
      'registration_first_name'
    when "student's last name"
      'registration_last_name'
    when "student's email"
      'registration_email'
    when "code"
      'coupon_code'
    when "amount"
      'coupon_amount'
    when 'organization'
      'registration_organization'
    when 'first name'
      'registration_first_name'
    when 'last name'
      'registration_last_name'
    when 'external registration url'
      'course_external_registration_url'
    when /question (\d+)/
      question_number = $1.to_i
      question_index = question_number - 1
      "course_questions_attributes_#{question_index}_question"
    when /answer (\d+)/
      answer_number = $1.to_i
      answer_index = answer_number - 1
      "course_questions_attributes_#{answer_index}_answer"
    when /follow up (\d+)/
      follow_up_number = $1.to_i
      follow_up_index = follow_up_number - 1
      "course_follow_ups_attributes_#{follow_up_index}_email"
    else
      raise %{Can't find a mapping from #{field_description.inspect} to an id: #{__FILE__}}
    end
  end

  def button_text_for(button_text)
    case button_text
    when 're-run a course', 'update a section'
      'Save Section'
    when 'add a teacher'
      'Save Teacher'
    when 'enroll a new student'
      'Save New Student'
    when 'sign in'
      'Sign in'
    when 'set the new password'
      'Save this password'
    else
      raise %{Can't find a mapping from #{button_text.inspect} to text: #{__FILE__}}
    end
  end

  def flash_text_for(flash_text)
    case flash_text
    when 'course creation'
      'Course was successfully created'
    when 'course update'
      'Course was successfully updated'
    when 'permission denied'
      'You do not have permission to view that page'
    when 'section creation'
      'Section was successfully created'
    when 'section update'
      'Section was successfully updated'
    when 'section enrollment'
      'Student has been enrolled'
    when 'sign out'
      'Signed out.'
    when 'sign in'
      'Signed in.'
    else
      raise %{Can't find a mapping from #{flash_text.inspect} to text: #{__FILE__}}
    end
  end
end

World(NavigationHelpers)
