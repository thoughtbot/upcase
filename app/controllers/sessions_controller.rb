class SessionsController < Clearance::SessionsController
  layout 'header-only'

  private

  def url_after_create
    if current_user.admin?
      admin_path
    else
      products_path
    end
  end
end
