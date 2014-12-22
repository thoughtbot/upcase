class Api::V1::UsersController < ApiController
  before_action :doorkeeper_authorize!

  def show
    respond_with user: resource_owner
  end
end
