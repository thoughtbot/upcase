require "rails_helper"

describe Repository do
  it_behaves_like 'a class inheriting from Product'

  it { should have_many(:collaborations).dependent(:destroy) }
  it { should belong_to(:trail) }

  it { should validate_presence_of(:github_repository) }
  it { should validate_presence_of(:github_url) }

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

        expect(fulfillment).not_to have_received(:remove)
      end
    end
  end

  describe "#has_github_collaborator?" do
    context "with GitHub access" do
      it "returns true" do
        user = build_stubbed(:user)
        repository = build_stubbed(:repository)
        client = stub_github_client
        allow(client).to receive(:collaborator?).
          with(repository.github_repository, user.github_username).
          and_return(true)

        expect(repository).to have_github_collaborator(user)
      end
    end

    context "without GitHub access" do
      it "returns false" do
        user = build_stubbed(:user)
        repository = build_stubbed(:repository)
        client = stub_github_client
        allow(client).to receive(:collaborator?).and_return(false)

        expect(repository).not_to have_github_collaborator(user)
      end
    end

    def stub_github_client
      double("github_client").tap do |client|
        allow(Octokit::Client).to receive(:new).
          with(login: GITHUB_USER, password: GITHUB_PASSWORD).
          and_return(client)
      end
    end
  end

  describe ".top_level" do
    it "returns repositories without parent trails" do
      trail = create(:trail)
      create(:repository, name: "with_trail", trail: trail)
      create(:repository, name: "no_parent1", trail: nil)
      create(:repository, name: "no_parent2", trail: nil)

      result = Repository.top_level

      expect(result.map(&:name)).to match_array(%w(no_parent1 no_parent2))
    end
  end

  def stub_fulfillment(repository, user)
    spy("fulfillment").tap do |fulfillment|
      allow(fulfillment).to receive(:fulfill)
      allow(fulfillment).to receive(:remove)
      allow(GithubFulfillment).to receive(:new).
        with(repository, user).
        and_return(fulfillment)
    end
  end
end
