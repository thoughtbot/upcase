class Api::V1::UsersController < ApiController
  doorkeeper_for :all

  def show
    respond_with resource_owner
  end
end
