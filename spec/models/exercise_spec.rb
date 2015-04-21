require "rails_helper"

describe Exercise do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }
  it { should have_one(:trail).through(:step) }
  it { should have_one(:step).dependent(:destroy) }

  describe ".ordered" do
    it "returns older exercises first" do
      create(:exercise, name: "first", created_at: 3.days.ago)
      create(:exercise, name: "third", created_at: 1.day.ago)
      create(:exercise, name: "second", created_at: 2.days.ago)

      expect(Exercise.ordered.pluck(:name)).to eq(%w(first second third))
    end
  end
end
