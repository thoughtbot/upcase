class TeachersController < ApplicationController
  before_filter :must_be_admin

  def new
    @course = Course.find(params[:course_id])
    @teacher = Teacher.new
  end

  def create
    @course = Course.find(params[:course_id])
    @teacher = Teacher.new(params[:teacher])
    if @teacher.save
      redirect_to new_course_section_url(@course)
    else
      render :new
    end
  end
end
