require "rails_helper"

RSpec.describe "trails/_repositories.html" do
  context "with repositories" do
    it "renders a link to each repository" do
      repositories = build_stubbed_list(:repository, 2)
      trail = build_stubbed(:trail, repositories: repositories)

      render "trails/repositories", trail: trail

      repositories.each do |repository|
        expect(rendered).to have_link_to(repository)
      end
    end
  end

  context "with no repositories" do
    it "doesn't render anything" do
      trail = build_stubbed(:trail, repositories: [])

      render "trails/repositories", trail: trail

      expect(rendered).to be_blank
    end
  end
end
