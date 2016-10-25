require "rails_helper"

describe RecommendableContent do
  it { should belong_to(:recommendable) }

  describe "uniqueness criteria" do
    before { create(:recommendable_content) }

    it { should validate_uniqueness_of(:position) }
  end

  describe ".priority_ordered" do
    it "returns the recommendable_content in position order" do
      first, second, third = create_list(:recommendable_content, 3)

      third.insert_at(1)
      ordered = RecommendableContent.priority_ordered

      expect(ordered).to match_array([third, first, second])
    end
  end
end
