require "rails_helper"

describe Repository do
  it_behaves_like 'a class inheriting from Product'

  it { should belong_to(:trail).optional }

  it { should validate_presence_of(:github_repository) }
  it { should validate_presence_of(:github_url) }

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
end
