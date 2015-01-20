module OAuthSupport
  def stub_oauth_authenticated_user
    build_stubbed(:user).tap do |user|
      User.stubs(:find).returns(user)
      access_token = build_stubbed(:oauth_access_token, user: user)
      Doorkeeper::OAuth::Token.stubs(:authenticate).returns(access_token)
    end
  end
end

RSpec.configure do |config|
  config.include OAuthSupport, type: :controller
end
