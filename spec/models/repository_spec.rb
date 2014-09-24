require "rails_helper"

describe Repository do
  it_behaves_like 'a class inheriting from Product'

  it { should validate_presence_of(:github_team) }
  it { should validate_presence_of(:github_url) }

  describe "#included_in_plan?" do
    it "delegates to the plan's source code feature" do
      expected = stub("plan.has_feature?(:source_code)")
      plan = stub("plan")
      plan.stubs(:has_feature?).with(:source_code).returns(expected)
      repository = Repository.new

      result = repository.included_in_plan?(plan)

      expect(result).to eq(expected)
    end
  end
end
