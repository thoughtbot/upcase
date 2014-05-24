require 'spec_helper'

describe 'purchases/_github_repo_info.html.erb' do
  context 'when the product is a book product' do
    it 'displays a link to the GitHub repository' do
      purchaseable = build_stubbed(:book, :github)

      render 'purchases/github_repo_info', purchaseable: purchaseable

      expect(rendered).to include(purchaseable.github_url)
    end
  end
end
