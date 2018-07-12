module TeacherHelper
  def teacher_names(teachers)
    teachers.map(&:name).to_sentence
  end

  def teacher_gravatar(teacher, size=20)
    image_tag(gravatar_url(teacher.email, size: size), alt: teacher.name)
  end
end
