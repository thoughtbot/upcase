class CoursesController < ApplicationController
  before_filter :must_be_admin

  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(params[:course])
    if @course.save
      flash[:success] = 'Course was successfully created.'
      redirect_to courses_url
    else
      render :new
    end
  end

  protected

  def must_be_admin
    unless current_user && current_user.admin?
      flash[:error] = 'You do not have permission to view that page.'
      redirect_to root_url
    end
  end
end
