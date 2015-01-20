class Api::V1::UsersController < ApiController
  before_action :doorkeeper_authorize!

  def show
    respond_with UserSerializer.new(resource_owner)
  end
end
