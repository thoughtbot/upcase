require "spec_helper"

describe "licenses/_github_repo_info.html.erb" do
  context "when the product is a book product" do
    it "displays a link to the GitHub repository" do
      product = build_stubbed(:book, :github)

      render "licenses/github_repo_info", offering: product

      expect(rendered).to include(product.github_url)
    end
  end
end
