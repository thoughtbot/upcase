require "rails_helper"

describe Topic do
  # Associations
  it { should have_many(:classifications).dependent(:destroy) }
  it { should have_many(:products).through(:classifications) }
  it { should have_many(:topics).through(:classifications) }
  it { should have_many(:videos).through(:classifications) }
  it { should have_many(:trails) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }

  context '.create' do
    before do
      @topic = create(:topic, name: ' Test Driven Development ')
    end

    it 'generates a stripped, url encoded slug based on name' do
      expect(@topic.slug).to eq "test-driven-development"
    end
  end

  context ".explorable" do
    it "returns topics to be displayed on the explore page" do
      create(:topic, :explorable, name: "one")
      create(:topic, :explorable, name: "two")
      create(:topic, :explorable, name: "three")
      create(:topic, name: "hidden")

      result = Topic.explorable

      expect(result.map(&:name)).to eq(%w(one two three))
    end
  end

  context "self.with_colors" do
    it "returns topics with colors" do
      _without_color = create(:topic, color: "")
      with_color = create(:topic, color: "yellow")

      expect(Topic.with_colors).to eq([with_color])
    end
  end

  context 'validations' do
    context 'uniqueness' do
      before do
        create :topic
      end

      it { should validate_uniqueness_of(:slug) }
    end
  end

  describe '#meta_keywords' do
    it 'returns a comma delimited string of topics' do
      create(:topic, name: 'Ruby')
      create(:topic, name: 'Rails')

      result = Topic.meta_keywords

      expect(result).to eq 'Ruby, Rails'
    end
  end
end
