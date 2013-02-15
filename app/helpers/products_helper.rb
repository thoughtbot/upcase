module ProductsHelper
  def test_driven_rails_url
    'https://learn.thoughtbot.com/workshops/18-test-driven-rails'
  end

  def design_for_developers_url
    'https://learn.thoughtbot.com/workshops/19-design-for-developers'
  end

  def purchase_button_text(product)
    if current_user_has_active_subscription?
      I18n.t('products.show.purchase_for_subscribed_user', product_type: product.product_type)
    else
      if product.subscription?
        I18n.t('products.show.purchase_subscription')
      else
        I18n.t('products.show.purchase_for_yourself')
      end
    end
  end
end
