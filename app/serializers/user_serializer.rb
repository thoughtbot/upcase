class UserSerializer < ActiveModel::Serializer
  attributes :email, :first_name, :last_name, :has_forum_access, :id

  def has_forum_access
    object.has_active_subscription? || object.admin?
  end
end
