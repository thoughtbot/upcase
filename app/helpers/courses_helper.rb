module CoursesHelper
  def courses_json(courses, callback = nil)
    json = courses.map! do |course|
      course_json = course.as_json
      course_json['course'].merge!(url: course_url(course))
      course_json
    end.to_json
    json = "#{callback}(#{json})" if callback
    json.html_safe
  end
end
