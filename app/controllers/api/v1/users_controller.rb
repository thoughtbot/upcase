class Api::V1::UsersController < ApplicationController
  doorkeeper_for :all

  respond_to :json

  def show
    respond_with current_resource_owner.to_json(
      only: [:id, :first_name, :last_name, :email],
      methods: :has_active_subscription?)
  end

  private

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id)
  end
end
