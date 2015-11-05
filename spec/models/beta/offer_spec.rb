require "rails_helper"

describe Beta::Offer do
  it { is_expected.to have_many(:replies).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }

  describe "#most_recent_first" do
    it "returns most recent offers first" do
      create :beta_offer, name: "one", created_at: 1.day.ago
      create :beta_offer, name: "three", created_at: 3.days.ago
      create :beta_offer, name: "two", created_at: 2.days.ago

      result = Beta::Offer.most_recent_first

      expect(result.map(&:name)).to eq(%w(one two three))
    end
  end
end
