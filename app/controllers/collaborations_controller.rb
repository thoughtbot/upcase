class CollaborationsController < ApplicationController
  def create
    require_sign_in do
      require_access_to(:repositories) do
        add_collaborator
      end
    end
  end

  private

  def add_collaborator
    repository = find_repository
    repository.add_collaborator(current_user)
    redirect_to repository
  end

  def find_repository
    Repository.friendly.find(params[:repository_id])
  end

  def require_sign_in
    if signed_in?
      yield
    else
      redirect_to(
        new_subscription_path,
        notice: t("subscriptions.flashes.subscription_required")
      )
    end
  end

  def require_access_to(feature)
    if current_user.has_access_to?(feature)
      yield
    else
      redirect_to(
        edit_subscription_path,
        notice: t("subscriptions.flashes.upgrade_required")
      )
    end
  end
end
