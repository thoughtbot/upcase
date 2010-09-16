class Registration < ActiveRecord::Base
  belongs_to :section
  belongs_to :user

  validates_associated :user

  def assign_user(user_params)
    if User.exists?(:email => user_params[:email])
      self.user = User.find_by_email(user_params[:email])
    else
      self.user = build_user(user_params.
                             merge(:password => '12343', :password_confirmation => '12343'))
    end
  end
end
