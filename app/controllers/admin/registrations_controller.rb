class Admin::RegistrationsController < ApplicationController
  before_filter :must_be_admin, :only => [:new, :create,:edit]

  def new
    @section = Section.find(params[:section_id])
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:user][:email]) || build_new_user
    if @user.save
      @section      = Section.find(params[:section_id])
      @registration = @section.registrations.build
      @registration.user = @user
      @registration.save
      flash[:success] = "Student has been enrolled"
      redirect_to edit_admin_course_section_path(@section.course, @section)
    else
      render :new
    end
  end

  def destroy
    @section = Section.find(params[:section_id])
    @registration = @section.registrations.find(params[:id])
    @registration.destroy
    flash[:success] = "Student registration has been deleted"
    redirect_to edit_admin_course_section_path(@section.course, @section)
  end

  private

  def build_new_user
    random_password = Digest::SHA1.hexdigest(Time.now.to_s)
    User.new(params[:user].merge(:password              => random_password,
                                 :send_set_password     => true ))
  end
end
