require "rails_helper"

describe CollaborationsController do
  describe "#create" do
    context "as a user with a subscription and access to repos" do
      it "adds the current user as a collaborator" do
        current_user = stub_user(repositories: true)
        repository = stub_repository

        sign_in_as current_user
        post :create, repository_id: repository.to_param

        expect(repository).to have_received(:add_collaborator).
          with(current_user)
        expect(controller).to redirect_to(repository)
      end

      it "sends an event noting the user has become a collaborator " do
        current_user = stub_user(repositories: true)
        repository = stub_repository

        sign_in_as current_user
        post :create, repository_id: repository.to_param

        expect(analytics).to(
          have_tracked("Created Collaboration").
          for_user(current_user).
          with_properties(repository_name: repository.name)
        )
      end
    end

    context "as a user with a subscription but no access to repos" do
      it "redirects to the plans page" do
        current_user = stub_user(repositories: false)
        repository = stub_repository

        sign_in_as current_user
        post :create, repository_id: repository.to_param

        expect(repository).not_to have_received(:add_collaborator)
        expect(controller).to redirect_to(edit_subscription_path)
        expect(controller).to set_flash.to(
          I18n.t("subscriptions.flashes.upgrade_required")
        )
      end
    end

    context "as a visitor" do
      it "redirects to the landing page" do
        repository = stub_repository

        post :create, repository_id: repository.to_param

        expect(repository).not_to have_received(:add_collaborator)
        expect(controller).to redirect_to(root_path)
        expect(controller).to set_flash.to(
          I18n.t("subscriptions.flashes.subscription_required")
        )
      end
    end
  end

  def stub_user(repositories:)
    build_stubbed(:user).tap do |user|
      allow(user).to receive(:has_access_to?).with(Repository).
        and_return(repositories)
    end
  end

  def stub_repository
    build_stubbed(:repository).tap do |repository|
      finder = spy("finder")
      allow(finder).to receive(:find).with(repository.to_param).
        and_return(repository)
      allow(Repository).to receive(:friendly).and_return(finder)

      allow(repository).to receive(:add_collaborator)
    end
  end
end
