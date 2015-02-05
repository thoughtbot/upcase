module OAuthSupport
  def stub_oauth_authenticated_user
    build_stubbed(:user).tap do |user|
      allow(User).to receive(:find).and_return(user)
      access_token = build_stubbed(:oauth_access_token, user: user)
      allow(Doorkeeper::OAuth::Token).to receive(:authenticate).
        and_return(access_token)
    end
  end
end

RSpec.configure do |config|
  config.include OAuthSupport, type: :controller
end
