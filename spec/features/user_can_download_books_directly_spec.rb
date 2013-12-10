require 'spec_helper'

feature 'User can download books directly' do
  scenario 'User sees links for various book formats' do
    user = create(:user)
    product = create(:book, :github, name: 'test github')
    create(:purchase, user: user, purchaseable: product)

    visit product_path(product, as: user)

    page.should have_css("a[href*='test-github.pdf']")
    page.should have_css("a[href*='test-github.epub']")
    page.should have_css("a[href*='test-github.mobi']")
  end

end
