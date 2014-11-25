require "rails_helper"

describe RepositoriesController do
  describe "#show" do
    context "with a license and GitHub access" do
      it "redirects to the repository on GitHub" do
        repository = build_stubbed(:repository)

        show_repository repository, license: true, github_access: true

        expect(response).to redirect_to(repository.github_url)
      end
    end

    context "with a license but no GitHub access" do
      it "renders status for the repository" do
        repository = build_stubbed(:repository)

        show_repository repository, license: true, github_access: false

        expect(controller).to render_template("repositories/status")
      end
    end

    context "with no license" do
      it "renders the product template" do
        repository = build_stubbed(:repository)

        show_repository repository, license: false, github_access: false

        expect(controller).to render_template("repositories/show")
      end
    end

    it "doesn't recognize other formats" do
      user = build_stubbed(:user)
      sign_in_as user
      repository = create(:repository)

      expect do
        get :show, id: repository.to_param, format: :json
      end.to raise_exception(ActionController::UnknownFormat)
    end
  end

  def show_repository(repository, license:, github_access:)
    user = build_stubbed(:user)
    finder = stub("finder")
    finder.stubs(:find).with(repository.to_param).returns(repository)
    Repository.stubs(:friendly).returns(finder)
    offering = stub("offering", user_has_license?: license)
    Offering.stubs(:new).with(repository, user).returns(offering)
    repository.stubs(:has_github_member?).with(user).returns(github_access)

    sign_in_as user
    get :show, id: repository.to_param
  end
end
