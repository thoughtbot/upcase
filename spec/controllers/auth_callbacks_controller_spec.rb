require "rails_helper"

describe AuthCallbacksController do
  context '#create' do
    it 'redirects to the dashboard path without an auth origin' do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
      request.env['omniauth.origin'] = nil

      get :create, provider: 'github'

      should redirect_to(dashboard_url)
    end
  end
end
