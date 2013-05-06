class UserSerializer < ActiveModel::Serializer
  attributes :email, :first_name, :has_forum_access, :id, :last_name

  def has_forum_access
    object.has_active_subscription? || object.admin?
  end
end
