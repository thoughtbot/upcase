class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(params[:course])
    @course.save
    flash[:success] = 'Course was successfully created.'
    redirect_to courses_url
  end
end
