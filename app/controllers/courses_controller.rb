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

  def edit
    @course = Course.find(params[:id])
    render
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course])
      flash[:success] = 'Course was successfully updated.'
      redirect_to courses_url
    else
      render :action => 'edit'
    end
  end
end
