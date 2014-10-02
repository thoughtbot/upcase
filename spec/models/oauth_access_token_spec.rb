require "rails_helper"

describe '.for_user' do
  it 'returns the last access token for a given user' do
    user = create(:user)
    token = create(:oauth_access_token, user: user)

    expect(OauthAccessToken.for_user(user).token).to eq token.token
  end

end
