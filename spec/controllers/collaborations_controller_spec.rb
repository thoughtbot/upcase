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
    end

    context "as a user with a subscription but no access to repos" do
      it "redirects to the plans page" do
        current_user = stub_user(repositories: false)
        repository = stub_repository

        sign_in_as current_user
        post :create, repository_id: repository.to_param

        expect(repository).to have_received(:add_collaborator).never
        expect(controller).to redirect_to(edit_subscription_path)
        expect(controller).to set_the_flash.to(
          I18n.t("subscriptions.flashes.upgrade_required")
        )
      end
    end

    context "as a visitor" do
      it "redirects to the sign up page" do
        repository = stub_repository

        post :create, repository_id: repository.to_param

        expect(repository).to have_received(:add_collaborator).never
        expect(controller).to redirect_to(new_subscription_path)
        expect(controller).to set_the_flash.to(
          I18n.t("subscriptions.flashes.subscription_required")
        )
      end
    end
  end

  def stub_user(repositories:)
    build_stubbed(:user).tap do |user|
      user.stubs(:has_access_to?).with(:repositories).returns(repositories)
    end
  end

  def stub_repository
    build_stubbed(:repository).tap do |repository|
      finder = stub("finder")
      finder.stubs(:find).with(repository.to_param).returns(repository)
      Repository.stubs(:friendly).returns(finder)

      repository.stubs(:add_collaborator)
    end
  end
end
