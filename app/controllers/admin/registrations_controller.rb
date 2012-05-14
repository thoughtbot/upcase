class Admin::RegistrationsController < ApplicationController
  before_filter :must_be_admin, :only => [:new, :create,:edit]

  def new
    @section = Section.find(params[:section_id])
    @registration = @section.registrations.build
  end

  def create
    @section = Section.find(params[:section_id])
    @registration = @section.registrations.build(params[:registration])
    if @registration.save
      flash[:success] = "Student has been enrolled"
      redirect_to edit_admin_course_section_path(@section.course, @section)
    else
      render :new
    end
  end

  def update
    section = Section.find(params[:section_id])
    registration = section.registrations.find(params[:id])
    registration.update_attributes(params[:registration])
    redirect_to edit_admin_section_url(section)
  end

  def destroy
    @section = Section.find(params[:section_id])
    @registration = @section.registrations.find(params[:id])
    @registration.destroy
    flash[:success] = "Student registration has been deleted"
    redirect_to edit_admin_course_section_path(@section.course, @section)
  end
end
