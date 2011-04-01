class SessionsController < Clearance::SessionsController
  private

  def url_after_create
    if current_user.admin?
      admin_path
    else
      root_path
    end
  end
end
