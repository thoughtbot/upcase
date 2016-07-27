require "rails_helper"

describe RecommendableContent do
  it { should belong_to(:recommendable) }
  it { should validate_presence_of(:position) }

  describe "uniqueness criteria" do
    before { create(:recommendable_content) }

    it { should validate_uniqueness_of(:position) }
  end

  describe ".in_order" do
    it "returns the recommendable_content in position order" do
      first, second, third = create_list(:recommendable_content, 3)

      third.insert_at(1)
      ordered = RecommendableContent.in_order

      expect(ordered).to match_array([third, first, second])
    end
  end
end
