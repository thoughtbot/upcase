module TeacherHelper
  def teacher_label
    Proc.new do |teacher|
      teacher_gravatar(teacher)+h(teacher.name)
    end
  end

  def teacher_gravatar(teacher, size=20)
    image_tag("https://secure.gravatar.com/avatar/#{teacher.gravatar_hash}?s=#{size}", alt: teacher.name)
  end
end
