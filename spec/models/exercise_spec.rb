require "rails_helper"

describe Exercise do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:url) }
  it { should have_many(:classifications) }
  it { should have_many(:topics).through(:classifications) }
  it { should have_many(:steps).dependent(:destroy) }

  describe ".ordered" do
    it "returns older exercises first" do
      create(:exercise, title: "first", created_at: 3.days.ago)
      create(:exercise, title: "third", created_at: 1.day.ago)
      create(:exercise, title: "second", created_at: 2.days.ago)

      expect(Exercise.ordered.pluck(:title)).to eq(%w(first second third))
    end
  end

  describe ".public" do
    it "only returns public exercises" do
      create(:exercise, title: "first", public: true)
      create(:exercise, title: "second", public: true)
      create(:exercise, title: "hidden", public: false)

      expect(Exercise.public.pluck(:title)).to match_array(%w(first second))
    end
  end
end
