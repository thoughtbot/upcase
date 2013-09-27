class SessionsController < Clearance::SessionsController
  layout 'header-only'

  private

  def return_to
    session[:return_to] || params[:return_to]
  end

  def url_after_create
    if current_user.admin?
      admin_path
    else
      dashboard_path
    end
  end
end
