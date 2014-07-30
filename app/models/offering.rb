class Offering
  attr_accessor :licenseable

  def initialize(licenseable, user)
    @licenseable = licenseable
    @user = user
  end

  def user_has_license?
    licenseable.license_for(user).present?
  end

  def license
    licenseable.license_for(user)
  end

  def method_missing(method_name, *arguments, &block)
    if licenseable.respond_to?(method_name)
      licenseable.send(method_name, *arguments, &block)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    licenseable.respond_to?(method_name) || super
  end

  private

  attr_accessor :user
end
