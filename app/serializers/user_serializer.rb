class UserSerializer < ActiveModel::Serializer

  attributes(
    :admin,
    :email,
    :first_name,
    :username,
    :has_active_subscription,
    :has_forum_access,
    :id,
    :last_name,
    :public_keys
  )

  def has_forum_access
    object.has_active_subscription? || object.admin?
  end

  def has_active_subscription
    object.has_active_subscription?
  end

  def public_keys
    object.public_keys.map(&:data)
  end

  def username
    object.github_username
  end
end
