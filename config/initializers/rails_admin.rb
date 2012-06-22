# RailsAdmin config file. Generated on May 30, 2012 16:34
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|
  config.authenticate_with do
    unless current_user
      session[:return_to] = request.url
      redirect_to "/sign_in", :alert => "You must first log in or sign up before accessing this page."
    end
  end

  config.authorize_with do
    redirect_to "/", :alert => "You are not authorized to access that page" unless current_user.admin?
  end

  config.current_user_method { current_user }

  config.main_app_name = ['Workshops', 'Admin']
end
