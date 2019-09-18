class UpdateOauthAccessGrantsScopesDefaults < ActiveRecord::Migration[5.2]
  def change
    change_column_default :oauth_access_grants, :scopes, ''
    change_column_null :oauth_access_grants, :scopes, false
  end
end
