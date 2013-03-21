module ProductsHelper
  def test_driven_rails_url
    'https://learn.thoughtbot.com/workshops/18-test-driven-rails'
  end

  def design_for_developers_url
    'https://learn.thoughtbot.com/workshops/19-design-for-developers'
  end

  def intermediate_rails_url
    'https://learn.thoughtbot.com/workshops/21-intermediate-ruby-on-rails'
  end

  def company_prime_path
    '/products/15-prime-for-teams'
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

  def cover_image(book)
    "product_images/book/#{book.sku.downcase}-cover-large.png"
  end

  def epub_url(book)
    "#{book.github_url}/blob/master/release/#{book.book_filename}.epub?raw=true"
  end

  def pdf_url(book)
    "#{book.github_url}/blob/master/release/#{book.book_filename}.pdf?raw=true"
  end

  def kindle_url(book)
    "#{book.github_url}/blob/master/release/#{book.book_filename}.mobi?raw=true"
  end

  def book_releases_url(book)
    "#{book.github_url}/tree/master/release"
  end
end
