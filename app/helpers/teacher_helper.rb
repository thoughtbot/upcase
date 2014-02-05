module TeacherHelper
  def teacher_label
    Proc.new do |teacher|
      teacher_gravatar(teacher)+h(teacher.name)
    end
  end

  def teacher_gravatar(teacher, size=20)
    image_tag(gravatar_url(teacher.email, size: size), alt: teacher.name)
  end
end
