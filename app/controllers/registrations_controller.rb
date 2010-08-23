# This is hit by Chargify.
class RegistrationsController < ApplicationController
  def index
    section  = Section.find(params[:section_id])
    user     = Customer.user_from_customer_id(params[:customer_id]) # raise 404 as needed
    user.save!
    sign_in(user)
    redirect_to section
  end
end
