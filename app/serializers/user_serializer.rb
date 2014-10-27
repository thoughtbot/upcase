class UserSerializer < ActiveModel::Serializer
  include Gravatarify::Helper

  attributes(
    :admin,
    :avatar_url,
    :email,
    :first_name,
    :has_active_subscription,
    :has_forum_access,
    :id,
    :last_name,
    :username
  )

  def has_forum_access
    object.has_access_to?(:forum) || object.admin?
  end

  def has_active_subscription
    object.has_active_subscription?
  end

  def username
    object.github_username
  end

  def avatar_url
    gravatar_url(object.email)
  end
end
