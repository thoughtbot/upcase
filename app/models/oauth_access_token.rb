class OauthAccessToken < ActiveRecord::Base
  def self.for_user(user)
    where(resource_owner_id: user.id).last
  end

  def self.for_forum
    where(<<-SQL.squish)
      application_id IN (
        SELECT id
        FROM oauth_applications
        WHERE redirect_uri LIKE '%forum%'
      )
    SQL
  end
end
