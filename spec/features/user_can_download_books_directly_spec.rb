require 'spec_helper'

feature 'User can download books directly' do
  scenario 'User sees links for various book formats' do
    user = create(:user, :with_github)
    product = create(:book, :github, name: 'test github')
    create(:license, user: user, licenseable: product)

    visit book_url(product, as: user)

    expect(page).to have_css("a[href*='test-github.pdf']")
    expect(page).to have_css("a[href*='test-github.epub']")
    expect(page).to have_css("a[href*='test-github.mobi']")
  end
end
