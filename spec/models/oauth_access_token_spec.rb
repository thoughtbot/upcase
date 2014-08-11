require "rails_helper"

describe '.for_user' do
  it 'returns the last access token for a given user' do
    user = create(:user)
    token = create(:oauth_access_token, resource_owner_id: user.id)

    expect(OauthAccessToken.for_user(user)).to eq token
  end

end
