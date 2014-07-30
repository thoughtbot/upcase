class Offering
  def initialize(licenseable, user)
    @licenseable = licenseable
    @user = user
  end

  def user_has_license?
    licenseable.license_for(user)
  end
end
