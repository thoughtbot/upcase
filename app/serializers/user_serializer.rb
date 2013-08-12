class UserSerializer < ActiveModel::Serializer
  attributes :email, :first_name, :last_name, :has_forum_access, :admin,
    :has_active_subscription, :id

  def has_forum_access
    object.has_active_subscription? || object.admin?
  end

  def has_active_subscription
    object.has_active_subscription?
  end
end
