require "rails_helper"

describe RepositoriesController do
  describe "#show" do
    context "with collaboration and GitHub access" do
      it "redirects to the repository on GitHub" do
        repository = stub_repository(collaborator: true, github_access: true)

        show_repository repository

        expect(response).to redirect_to(repository.github_url)
      end
    end

    context "with collaboration but no GitHub access" do
      it "renders status for the repository" do
        repository = stub_repository(collaborator: true, github_access: false)

        show_repository repository

        expect(controller).to render_template("repositories/status")
      end
    end

    context "with no collaboration" do
      it "renders the product template" do
        repository = stub_repository(collaborator: false, github_access: false)

        show_repository repository

        expect(controller).to render_template("repositories/show")
      end
    end

    it "doesn't recognize other formats" do
      repository = stub_repository

      expect do
        show_repository repository, format: :json
      end.to raise_exception(ActionController::UnknownFormat)
    end
  end

  def stub_repository(collaborator: false, github_access: false)
    build_stubbed(:repository).tap do |repository|
      finder = stub("finder")
      finder.stubs(:find).with(repository.to_param).returns(repository)
      Repository.stubs(:friendly).returns(finder)

      repository.
        stubs(:has_collaborator?).
        with(current_user).
        returns(collaborator)
      repository.
        stubs(:has_github_member?).
        with(current_user).
        returns(github_access)
    end
  end

  def show_repository(repository, params = {})
    sign_in_as current_user
    get :show, params.merge(id: repository.to_param)
  end

  let(:current_user) { build_stubbed(:user) }
end
