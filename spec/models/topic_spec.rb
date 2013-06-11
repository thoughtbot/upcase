require 'spec_helper'

describe Topic do
  # Associations
  it { should have_many(:articles).through(:classifications) }
  it { should have_many(:classifications) }
  it { should have_many(:workshops).through(:classifications) }
  it { should have_many(:episodes).through(:classifications) }
  it { should have_many(:products).through(:classifications) }
  it { should have_many(:related_topics).through(:classifications) }
  it { should have_one(:trail) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }

  # Associations
  it { should allow_mass_assignment_of(:featured) }
  it { should allow_mass_assignment_of(:keywords) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:summary) }
  it { should allow_mass_assignment_of(:related_topic_ids) }

  context '.create' do
    before do
      @topic = create(:topic, name: ' Test Driven Development ')
    end

    it 'generates a stripped, url encoded slug based on name' do
      @topic.slug.should == 'test+driven+development'
    end
  end

  context 'self.top' do
    before do
      25.times do |i|
        create :topic, count: i, featured: true
      end
    end

    it 'returns the top 20 featured topics' do
      Topic.top.count.should == 20
      Topic.top.all? {|topic| topic.count >= 5 }.should be
    end
  end

  context 'self.featured' do
    it 'returns the featured topics' do
      normal = create(:topic, featured: false)
      featured = create(:topic, featured: true)
      Topic.featured.should include featured
      Topic.featured.should_not include normal
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
