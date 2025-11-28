require "rails_helper"

RSpec.describe CollaborationsController do
  describe "#create" do
    context "as a user with access to repos" do
      it "redirects to the repository" do
        current_user = stub_user(repositories: true)
        repository = stub_repository

        sign_in_as current_user
        post :create, params: {repository_id: repository.to_param}

        expect(controller).to redirect_to(repository)
      end
    end

    context "as a visitor" do
      it "redirects to the landing page" do
        repository = stub_repository

        post :create, params: {repository_id: repository.to_param}

        expect(controller).to redirect_to(root_path)
      end
    end
  end

  def stub_user(repositories:)
    build_stubbed(:user).tap do |user|
      allow(user).to receive(:has_access_to?).with(Repository)
        .and_return(repositories)
    end
  end

  def stub_repository
    build_stubbed(:repository).tap do |repository|
      finder = spy("finder")
      allow(finder).to receive(:find).with(repository.to_param)
        .and_return(repository)
      allow(Repository).to receive(:friendly).and_return(finder)
    end
  end
end
