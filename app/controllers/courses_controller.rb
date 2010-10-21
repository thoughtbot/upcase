class CoursesController < ApplicationController
  before_filter :must_be_admin, :except => [:show]
  layout 'admin'

  def index
    @courses = Course.all
    render
  end

  def show
    @course = Course.find(params[:id])
    @follow_up = @course.follow_ups.build
    render :layout => 'application'
  end

  def new
    @course = Course.new
    render
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
      render 'edit'
    end
  end
end
