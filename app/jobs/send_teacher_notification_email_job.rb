class SendTeacherNotificationEmailJob < Struct.new(:teacher_id, :section_id)
  include ErrorReporting

  def self.enqueue(teacher_id, section_id)
    Delayed::Job.enqueue(new(teacher_id, section_id))
  end

  def perform
    teacher = Teacher.find(teacher_id)
    section = Section.find(section_id)

    Mailer.teacher_notification(teacher, section).deliver
  end
end
