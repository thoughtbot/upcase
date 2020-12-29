require "single_sign_on"

class ForumSessionsController < ApplicationController
  before_action :require_login

  def new
    sso = ::SingleSignOn.parse(
      request.query_string,
      ENV.fetch("DISCOURSE_SSO_SECRET"),
    )
    populate_sso_for_current_user(sso)

    redirect_to sso.to_url(Forum.sso_url)
  end

  private

  def populate_sso_for_current_user(sso)
    single_sign_on_mapping.each do |sso_attr, user_attr|
      sso.send("#{sso_attr}=", current_user.send(user_attr))
    end
    sso.sso_secret = ENV["DISCOURSE_SSO_SECRET"]
  end

  def single_sign_on_mapping
    {
      email: :email,
      name: :name,
      username: :github_username,
      external_id: :id,
    }
  end
end
