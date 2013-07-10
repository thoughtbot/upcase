class OauthAccessToken < ActiveRecord::Base
  def self.for_user(user)
    where(resource_owner_id: user.id).last
  end
end
