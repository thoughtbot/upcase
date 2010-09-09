class SectionsController < ApplicationController
  before_filter :dashboard_if_admin, :only => [:index]

  def index
    @sections = Section.all
  end

  def show
    @section = Section.find(params[:id])

    render 'resources' if current_user.try(:registered_for?, @section)
  end

  def new
    @course = Course.find(params[:course_id])
    @section = @course.sections.build
    @teachers = Teacher.all
    @section.section_teachers.build
  end

  def create
    @course = Course.find(params[:course_id])
    @section = @course.sections.build(params[:section])
    @section.save
    flash[:success] = 'Section was successfully created'
    redirect_to courses_path
  end

  def edit
    @course = Course.find(params[:course_id])
    @section = @course.sections.find(params[:id])
    @teachers = Teacher.all
  end

  protected

  def dashboard_if_admin
    redirect_to courses_url if current_user.try(:admin?)
  end
end
