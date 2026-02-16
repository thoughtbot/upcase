require "rails_helper"

RSpec.describe RepositoriesController do
  describe "#show" do
    it "redirects to the repository on GitHub" do
      repository = build_stubbed(:repository)
      finder = double("finder")
      allow(finder)
        .to receive(:find)
        .with(repository.to_param)
        .and_return(repository)
      allow(Repository)
        .to receive(:friendly)
        .and_return(finder)
      sign_in_as build_stubbed(:user)

      get :show, params: {id: repository.to_param}

      expect(response).to redirect_to(repository.github_url)
    end
  end
end
