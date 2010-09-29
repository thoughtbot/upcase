module TeacherHelper
  def teacher_label
    Proc.new do |teacher|
      teacher_gravatar(teacher)+h(teacher.name)
    end
  end

  def teacher_gravatar(teacher)
    image_tag("http://www.gravatar.com/avatar/#{teacher.gravatar_hash}?s=20", :alt => teacher.name)
  end
end
