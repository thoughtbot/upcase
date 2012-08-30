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

  def sections_as_sentence(sections)
    cities_and_dates = sections_cities_and_dates(sections)
    if cities_and_dates.any?
      "In " + cities_and_dates.to_sentence
    end
  end

  private

  def sections_cities_and_dates(sections)
    sections.map { |section| "#{section.city} on #{section.date_range}" }
  end
end
