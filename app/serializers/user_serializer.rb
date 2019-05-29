class UserSerializer < ActiveModel::Serializer
  include Gravatarify::Helper

  type :user

  attributes(
    :admin,
    :avatar_url,
    :email,
    :first_name,
    :has_forum_access,
    :id,
    :last_name,
    :username
  )

  def has_forum_access
    object.has_access_to?(Forum) || object.admin?
  end

  def username
    object.github_username
  end

  def avatar_url
    gravatar_url(object.email)
  end
end
