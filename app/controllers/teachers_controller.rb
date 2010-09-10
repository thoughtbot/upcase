class TeachersController < ApplicationController
  def new
    @course = Course.find(params[:course_id])
    @teacher = Teacher.new
  end

  def create
    teacher = Teacher.new(params[:teacher])
    teacher.save
    course = Course.find(params[:course_id])
    redirect_to new_course_section_url(course)
  end
end
