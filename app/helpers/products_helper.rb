module ProductsHelper
  def test_driven_rails_url
    "https://upcase.com/test-driven-rails"
  end

  def design_for_developers_url
    "https://upcase.com/design-for-developers"
  end

  def intermediate_rails_url
    "https://upcase.com/intermediate-ruby-on-rails"
  end

  def completeable_link(url, options = {}, &block)
    if current_user_has_access_to?(:trails)
      link_to url, options, &block
    else
      link_to edit_subscription_path, options, &block
    end
  end
end
