require "rails_helper"

describe RepositoriesController do
  describe "#show" do
    it "redirects to the repository on GitHub" do
      repository = stub_repository

      show_repository repository

      expect(response).to redirect_to(repository.github_url)
    end
  end

  def stub_repository
    build_stubbed(:repository).tap do |repository|
      finder = double("finder")
      allow(finder).to receive(:find).with(repository.to_param)
        .and_return(repository)
      allow(Repository).to receive(:friendly).and_return(finder)
    end
  end

  def show_repository(repository, params = {})
    sign_in_as current_user
    get :show, params: params.merge(id: repository.to_param)
  end

  let(:current_user) { build_stubbed(:user) }
end
