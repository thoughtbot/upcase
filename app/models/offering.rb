class Offering < SimpleDelegator
  attr_accessor :licenseable

  def initialize(licenseable, user)
    @licenseable = licenseable
    @user = user
    super(@licenseable)
  end

  def user_has_license?
    licenseable.license_for(user).present?
  end

  def license
    licenseable.license_for(user)
  end

  private

  attr_accessor :user
end
