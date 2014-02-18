class IntercomUpdater
  SUBSCRIPTION_FLAG = 'has_active_subscription'

  def initialize(user)
    @user = user
  end

  def unsubscribe
    intercom_user.custom_data[SUBSCRIPTION_FLAG] = false
    intercom_user.save
  end

  private

  def intercom_user
    @intercom_user ||= Intercom::User.find_by_email(email)
  end

  attr_reader :user

  def email
    user.email
  end
end
