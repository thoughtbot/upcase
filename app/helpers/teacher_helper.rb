module TeacherHelper
  def teacher_label
    Proc.new do |teacher|
      image_tag("http://www.gravatar.com/avatar/#{teacher.gravatar_hash}?s=20")+h(teacher.name)
    end
  end
end
