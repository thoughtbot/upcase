module ApplicationHelper
  def body_class
    qualified_controller_name = controller.controller_path.gsub('/','-')
    "#{qualified_controller_name} #{qualified_controller_name}-#{controller.action_name}"
  end

  def google_map_link_to(address, *options, &block)
    google_link = "http://maps.google.com/maps?f=q&q=#{CGI.escape(address)}&z=17&iwloc=A"
    if block_given?
      link_to(capture(&block), google_link, *options)
    else
      link_to address, google_link, *options
    end
  end

  def keywords(keywords = nil)
    keywords.presence || Topic.all.pluck(:name).join(", ")
  end

  def github_auth_path
    '/auth/github'
  end

  def format_markdown(resources)
    BlueCloth.new(resources).to_html.html_safe
  end

  def partial_name(model)
    File.basename(model.to_partial_path)
  end

  def forum_url(suffix=nil)
    "https://forum.upcase.com/#{suffix}"
  end

  def blog_articles_url(topic)
    "http://robots.thoughtbot.com/tags/#{topic.slug}"
  end

  def show_upgrade_to_annual_cta?
    current_user_is_subscription_owner? &&
      current_user_is_eligible_for_annual_upgrade?
  end
end
