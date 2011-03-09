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
    @user         = current_user || User.new
    @section      = Section.find(params[:section_id])
    @registration = @section.registrations.build
  end

  def create
    @section      = Section.find(params[:section_id])
    if locate_user
      sign_in(@user) unless current_user
      @user.update_attributes(params[:user])
      section                = Section.find(params[:section_id])
      registration           = section.registrations.build
      registration.user      = @user
      registration.coupon    = Coupon.find_by_id_and_active(params[:coupon_id], true)
      if registration.save
        redirect_to registration.freshbooks_invoice_url
      else
        render :new
      end
    else
      flash[:failure] = 'Please check the errors below and correct them to register'
      render :new
    end
  end

  private

  def locate_user
    @user = current_user
    if @user
      @user
    else
      @user = User.new(params[:user])
      @user.save
    end
  end
end
