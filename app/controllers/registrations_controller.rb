class RegistrationsController < ApplicationController
  def index
    section  = Section.find(params[:section_id])
    user     = Customer.user_from_customer_id(params[:customer_id]) # raise 404 as needed
    user.registrations.build(:section => section)
    user.save!
    sign_in(user)
    redirect_to section
  end

  def new
    @section      = Section.find(params[:section_id])
    @registration = @section.registrations.build
    km.record("Started Registration", { "Course Name" => @section.course.name })
  end

  def create
    @section      = Section.find(params[:section_id])
    registration  = @section.registrations.build(params[:registration])
    registration.coupon = Coupon.find_by_id_and_active(params[:coupon_id], true)
    if registration.save
      km_http_client.record(registration.email, "Submitted Registration", { "Course Name" => @section.course.name })
      redirect_to registration.freshbooks_invoice_url
    else
      render :new
    end
  end
end
