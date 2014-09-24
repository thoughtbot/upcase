require "rails_helper"

describe Repository do
  it_behaves_like 'a class inheriting from Product'

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
end
