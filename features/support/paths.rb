module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /^the home\s?page$/
      '/'
    when 'the sign up page'
      sign_up_path
    when 'the sign in page'
      sign_in_path
    when 'the password reset request page'
      new_password_path
    when 'the list of courses'
      courses_path
    when /^the new section page for "([^"]+)"$/
      course = Course.find_by_name!($1)
      new_course_section_path(course)
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
    when /^re-run the course "([^"]+)"$/
      course = Course.find_by_name!($1)
      "new-section-#{course.id}"
    when /^the section from "([^"]+)" to "([^"]+)"$/
      section = Section.find_by_starts_on_and_ends_on!(Date.parse($1), Date.parse($2))
      "section_#{section.id}"
    when 'create a new teacher'
      'Create New Teacher'
    when 'add a new student'
      'Add Student'
    else
      raise %{Can't find a mapping from #{link_description.inspect} to a path: #{__FILE__}}
    end
  end

  def field_id_for(field_description)
    case field_description
    when 'course name'
      'course_name'
    when 'course description'
      'course_description'
    when 'course price'
      'course_price'
    when 'start time'
      'course_start_at'
    when 'end time'
      'course_stop_at'
    when 'location'
      'course_location'
    when 'location name'
      'course_location_name'
    when 'max students'
      'course_maximum_students'
    when 'terms of service'
      'course_terms_of_service'
    when 'reminder email text'
      'course_reminder_email'
    when 'that the course is public'
      'course_public'
    when 'section start'
      'section_starts_on'
    when 'section end'
      'section_ends_on'
    when 'section teacher'
      'section_section_teachers_attributes_0_teacher_id'
    when "teacher's name"
      'teacher_name'
    when "teacher's bio"
      'teacher_bio'
    when "teacher's email"
      'teacher_email'
    when "student's first name"
      'user_first_name'
    when "student's last name"
      'user_last_name'
    when "student's email"
      'user_email'
    else
      raise %{Can't find a mapping from #{field_description.inspect} to an id: #{__FILE__}}
    end
  end

  def button_text_for(button_text)
    case button_text
    when 'create a course'
      'Save Course'
    when 'submit the Chargify form'
      'Chargify Submit'
    when 're-run a course'
      'Save Section'
    when 'add a teacher'
      'Save Teacher'
    when 'enroll a new student'
      'Save New Student'
    else
      raise %{Can't find a mapping from #{button_text.inspect} to text: #{__FILE__}}
    end
  end

  def flash_text_for(flash_text)
    case flash_text
    when 'course creation'
      'Course was successfully created'
    when 'permission denied'
      'You do not have permission to view that page'
    when 'section creation'
      'Section was successfully created'
    else
      raise %{Can't find a mapping from #{flash_text.inspect} to text: #{__FILE__}}
    end
  end
end

World(NavigationHelpers)
