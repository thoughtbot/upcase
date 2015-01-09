require "rails_helper"

describe Repository do
  it_behaves_like 'a class inheriting from Product'

  it { should have_many(:collaborations).dependent(:destroy) }

  it { should validate_presence_of(:github_team) }
  it { should validate_presence_of(:github_url) }

  describe "#included_in_plan?" do
    it "delegates to the plan's repositories feature" do
      expected = stub("plan.has_feature?(:repositories)")
      plan = stub("plan")
      plan.stubs(:has_feature?).with(:repositories).returns(expected)
      repository = Repository.new

      result = repository.included_in_plan?(plan)

      expect(result).to eq(expected)
    end
  end

  describe "#has_collaborator?" do
    context "after #add_collaborator with that user" do
      it "returns true" do
        collaborator = create(:user)
        repository = create(:repository)
        repository.add_collaborator(collaborator)

        expect(repository).to have_collaborator(collaborator)
      end
    end

    context "after #add_collaborator with another user" do
      it "returns false" do
        collaborator = create(:user)
        non_collaborator = create(:user)
        repository = create(:repository)
        repository.add_collaborator(collaborator)

        expect(repository).not_to have_collaborator(non_collaborator)
      end
    end

    context "after #remove_collaborator" do
      it "returns false" do
        collaborator = create(:user)
        repository = create(:repository)
        repository.add_collaborator(collaborator)
        repository.remove_collaborator(collaborator)

        expect(repository).not_to have_collaborator(collaborator)
      end
    end
  end

  describe "#add_collaborator" do
    it "creates a GitHub fulfillment" do
      collaborator = build_stubbed(:user, :with_github)
      repository = build_stubbed(:repository)
      fulfillment = stub_fulfillment(repository, collaborator)

      repository.add_collaborator(collaborator)

      expect(fulfillment).to have_received(:fulfill)
    end
  end

  describe "#remove_collaborator" do
    context "for an existing collaborator" do
      it "removes fulfillment" do
        collaborator = create(:user)
        repository = create(:repository)
        fulfillment = stub_fulfillment(repository, collaborator)
        repository.add_collaborator(collaborator)

        repository.remove_collaborator(collaborator)

        expect(fulfillment).to have_received(:remove)
      end
    end

    context "for a non-collaborator" do
      it "doesn't remove fulfillment" do
        collaborator = create(:user)
        repository = create(:repository)
        fulfillment = stub_fulfillment(repository, collaborator)

        repository.remove_collaborator(collaborator)

        expect(fulfillment).to have_received(:remove).never
      end
    end
  end

  describe "#has_github_member?" do
    context "with GitHub access" do
      it "returns true" do
        user = build_stubbed(:user)
        repository = build_stubbed(:repository)
        client = stub_github_client
        client.
          stubs(:team_member?).
          with(repository.github_team, user.github_username).
          returns(true)

        expect(repository).to have_github_member(user)
      end
    end

    context "without GitHub access" do
      it "returns false" do
        user = build_stubbed(:user)
        repository = build_stubbed(:repository)
        client = stub_github_client
        client.stubs(:team_member?).returns(false)

        expect(repository).not_to have_github_member(user)
      end
    end

    def stub_github_client
      stub("github_client").tap do |client|
        Octokit::Client.
          stubs(:new).
          with(login: GITHUB_USER, password: GITHUB_PASSWORD).returns(client)
      end
    end
  end

  def stub_fulfillment(repository, user)
    stub("fulfillment").tap do |fulfillment|
      fulfillment.stubs(:fulfill)
      fulfillment.stubs(:remove)
      GithubFulfillment.
        stubs(:new).with(repository, user).
        returns(fulfillment)
    end
  end
end
