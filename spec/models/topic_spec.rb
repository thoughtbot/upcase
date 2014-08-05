require 'spec_helper'

describe Topic do
  # Associations
  it { should have_many(:classifications) }
  it { should have_many(:workshops).through(:classifications) }
  it { should have_many(:products).through(:classifications) }
  it { should have_many(:topics).through(:classifications) }
  it { should have_one(:trail) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }

  it_behaves_like 'it has related items'

  context '.create' do
    before do
      @topic = create(:topic, name: ' Test Driven Development ')
    end

    it 'generates a stripped, url encoded slug based on name' do
      expect(@topic.slug).to eq 'test+driven+development'
    end
  end

  context 'self.top' do
    before do
      25.times do |i|
        create :topic, count: i, featured: true
      end
    end

    it 'returns the top 20 featured topics' do
      expect(Topic.top.count).to eq 20
      expect(Topic.top.all? {|topic| topic.count >= 5 }).to be
    end
  end

  context 'self.featured' do
    it 'returns the featured topics' do
      normal = create(:topic, featured: false)
      featured = create(:topic, featured: true)
      expect(Topic.featured).to include featured
      expect(Topic.featured).not_to include normal
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
