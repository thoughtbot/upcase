class SessionsController < Clearance::SessionsController

  private

  def url_after_create
    if current_user.admin?
      admin_path
    else
      my_account_path
    end
  end
end
