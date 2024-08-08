class CollaborationsController < ApplicationController
  def create
    require_sign_in do
      redirect_to find_repository
    end
  end

  private

  def find_repository
    Repository.friendly.find(params[:repository_id])
  end

  def require_sign_in
    if signed_in?
      yield
    else
      redirect_to(
        root_path
      )
    end
  end
end
