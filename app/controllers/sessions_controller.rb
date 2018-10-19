class SessionsController < Clearance::SessionsController
  private

  def return_to
    session[:return_to] || params[:return_to]
  end

  def url_after_create
    practice_path
  end
end
