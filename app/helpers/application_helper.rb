module ApplicationHelper
  def referral_discount
    ENV.fetch("REFERRAL_DISCOUNT", "50")
  end

  def body_class
    qualified_controller_name = controller.controller_path.gsub('/','-')
    "#{qualified_controller_name} #{qualified_controller_name}-#{controller.action_name}"
  end

  def format_markdown(markdown)
    if markdown.present?
      renderer = Redcarpet::Markdown.new(
        Redcarpet::Render::HTML.new(with_toc_data: true),
        autolink: true,
        tables: true,
        fenced_code_blocks: true,
        no_intra_emphasis: true,
      )
      renderer.render(markdown).html_safe
    else
      ""
    end
  end

  def forum_url(suffix=nil)
    "https://forum.upcase.com/#{suffix}"
  end

  def exercise_path(exercise)
    exercise.url
  end

  def current_user_is_subscription_owner?
    current_user.subscriber? &&
      current_user.subscription.owner?(current_user)
  end

  def show_upgrade_to_annual_cta?
    current_user_is_subscription_owner? &&
      current_user.eligible_for_annual_upgrade?
  end

  def encourage_user_to_pay?
    !current_user.subscriber? || sales_context?
  end

  def content_meta_description(describable)
    describable.meta_description.presence ||
      t("shared.content_meta_description", name: describable.name)
  end

  def dynamic_page_title(titleable, type)
    titleable.page_title.presence ||
      t("dynamic_page_titles.#{type}", name: titleable.name)
  end

  def sign_in_path_with_current_path_return_to
    sign_in_path(return_to: request.fullpath)
  end

  def url_with_path_prefix
    "https://#{ENV.fetch('APP_DOMAIN')}/upcase"
  end

  def not_on_signin_path?
    !(params[:controller] == "sessions" && params[:action] == "new")
  end
end
