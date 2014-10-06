require "rails_helper"

describe ".for_user" do
  it "returns the last access token for a given user" do
    user = create(:user)
    token = create(:oauth_access_token, user: user)

    expect(OauthAccessToken.for_user(user).token).to eq token.token
  end
end

describe ".for_forum" do
  it "returns only access tokens that associated with forums" do
    forum = create(
      :oauth_application,
      redirect_uri: "http://forum.upcase.com/auth/upcase/callback"
    )
    exercise = create(
      :oauth_application,
      redirect_uri: "https://exercises.upcase.com/auth/upcase/callback"
    )
    forum_token = create(:oauth_access_token, application_id: forum.id)
    exercise_token = create(:oauth_access_token, application_id: exercise.id)

    expected_tokens = [forum_token.becomes(OauthAccessToken)]
    expect(OauthAccessToken.for_forum).to eq expected_tokens
  end
end
