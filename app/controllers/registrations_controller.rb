class RegistrationsController < ApplicationController
  before_filter :must_be_admin_or_chargify
  # This is hit by Chargify.
  def index
    section  = Section.find(params[:section_id])
    user     = Customer.user_from_customer_id(params[:customer_id]) # raise 404 as needed
    user.registrations.build(:section => section)
    user.save!
    sign_in(user)
    redirect_to section
  end

  def new
    @course = Course.find(params[:course_id])
    @section = @course.sections.find(params[:section_id])
    @registration = @section.registrations.build
    @user = @registration.build_user
  end

  def create
    @course = Course.find(params[:course_id])
    @section = @course.sections.find(params[:section_id])
    @registration = @section.registrations.build
    @registration.assign_user(params[:user])
    @user = @registration.user
    if @registration.save
      flash[:success] ='Student has been enrolled.'
      redirect_to edit_course_section_url(@course, @section)
    else
      render :new
    end
  end

  private

  def must_be_admin_or_chargify
    unless current_user.try(:admin?) || Customer.valid_subscription?(params[:subscription_id])
      flash[:error] = 'You do not have permission to view that page.'
      redirect_to root_url
    end
  end
end
