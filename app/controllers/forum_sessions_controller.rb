class ForumSessionsController < ApplicationController
  before_action :authorize
  before_action :must_have_forum_access

  def new
    sso = DiscourseSignOn.parse(
      request.query_string,
      ENV["DISCOURSE_SSO_SECRET"]
    )
    populate_sso_for_current_user(sso)

    redirect_to sso.to_url(Forum.sso_url)
  end

  private

  def must_have_forum_access
    unless current_user.has_access_to?(:forum)
      redirect_to(
        new_subscription_url,
        notice: I18n.t(
          "products.show.subscribe_cta",
          offering_type: "forum",
          subscription_name: I18n.t("shared.upcase")
        )
      )
    end
  end

  def populate_sso_for_current_user(sso)
    sso.email = current_user.email
    sso.name = current_user.name
    sso.username = current_user.github_username
    sso.external_id = current_user.id
    sso.sso_secret = ENV["DISCOURSE_SSO_SECRET"]
  end
end
