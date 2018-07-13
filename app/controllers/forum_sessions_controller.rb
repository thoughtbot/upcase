require "single_sign_on"

class ForumSessionsController < ApplicationController
  before_action :require_login
  before_action :must_have_forum_access

  def new
    sso = ::SingleSignOn.parse(
      request.query_string,
      ENV.fetch("DISCOURSE_SSO_SECRET"),
    )
    populate_sso_for_current_user(sso)
    track_forum_access

    redirect_to sso.to_url(Forum.sso_url)
  end

  private

  def must_have_forum_access
    unless current_user.has_access_to?(Forum)
      redirect_to(
        root_path,
        notice: I18n.t(
          "products.subscribe_cta",
          offering_type: "forum",
          subscription_name: I18n.t("shared.upcase")
        )
      )
    end
  end

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

  def track_forum_access
    analytics.track_accessed_forum
  end
end
