require 'spec_helper'

describe 'Discounted prices' do
  describe 'viewing a product with a discount' do
    it 'displays the sale price' do
      discount_title = 'Special discount'
      product = create(
        :product,
        discount_percentage: 20,
        discount_title: discount_title
      )

      visit product_path(product)

      expect(page).to have_css('.discount-title', text: discount_title)
      expect(page).to have_css('.individual-purchase', text: product.individual_price.to_i.to_s)
      expect(page).to have_css('.individual-purchase .original-price', text: product.original_individual_price.to_s)
      expect(page).to have_css('.company-purchase', text: product.company_price.to_i.to_s)
      expect(page).to have_css('.company-purchase .original-price', text: product.original_company_price.to_s)
    end
  end

  describe 'viewing a product without a temporary sale price' do
    it 'does not display the sale price' do
      discount_title = 'Special discount'
      product = create(
        :product,
        discount_percentage: 0,
        discount_title: discount_title
      )

      visit product_path(product)

      expect(page).not_to have_css('.discount-title')
      expect(page).not_to have_css('.individual-purchase .original-price')
      expect(page).not_to have_css('.company-purchase .original-price')
    end
  end
end
