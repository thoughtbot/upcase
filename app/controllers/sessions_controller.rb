class SessionsController < Clearance::SessionsController
  private

  def return_to
    session[:return_to] || params[:return_to]
  end

  def url_after_create
    onboarding_policy.root_path
  end
end
