module ProductsHelper
  def test_driven_rails_url
    'https://learn.thoughtbot.com/workshops/18-test-driven-rails'
  end

  def purchase_button_text(product)
    if product.subscription?
      I18n.t('products.show.purchase_subscription')
    else
      I18n.t('products.show.purchase_for_yourself')
    end
  end
end
