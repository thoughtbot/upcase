class SectionsController < ApplicationController
  before_filter :must_be_admin, :only => [:new, :create,:edit]

  def index
    @sections            = Section.active.by_starts_on
    @unscheduled_courses = Course.unscheduled
  end

  def show
    @section   = Section.find(params[:id])
    @follow_up = @section.course.follow_ups.build

    render 'resources' if current_user.try(:registered_for?, @section)
  end

  def new
    @course   = Course.find(params[:course_id])
    @section  = @course.sections.build
    @teachers = Teacher.all
    @section.section_teachers.build
  end

  def create
    @course  = Course.find(params[:course_id])
    @section = @course.sections.build(params[:section])
    if @section.save
      flash[:success] = 'Section was successfully created'
      redirect_to courses_path
    else
      @teachers = Teacher.all
      @section.section_teachers.build
      render :new
    end
  end

  def edit
    @course   = Course.find(params[:course_id])
    @section  = @course.sections.find(params[:id])
    @teachers = Teacher.all
  end

  def update
    @course   = Course.find(params[:course_id])
    @section  = @course.sections.find(params[:id])
    @teachers = Teacher.all
    if @section.update_attributes(params[:section])
      flash[:success] = 'Section was successfully updated'
      redirect_to courses_path
    else
      render 'edit'
    end
  end

  protected

  def dashboard_if_admin
    redirect_to courses_url if current_user.try(:admin?)
  end
end
