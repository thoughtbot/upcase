require 'spec_helper'

describe Topic do
  context 'associations' do
    it { should have_many(:classifications) }
    it { should have_many(:articles).through(:classifications) }
    it { should have_many(:products).through(:classifications) }
    it { should have_many(:courses).through(:classifications) }
  end

  context 'active_authorizer' do
    it { should_not allow_mass_assignment_of(:body_html) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:keywords) }
    it { should_not allow_mass_assignment_of(:name) }
    it { should_not allow_mass_assignment_of(:slug) }
    it { should_not allow_mass_assignment_of(:summary) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  context 'create' do
    before do
      @topic = create(:topic, name: ' Test Driven Development ')
    end

    it 'generates slug based on name' do
      @topic.slug.should == 'test-driven-development'
    end
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }

    context 'uniqueness' do
      before do
        create :topic
      end

      it { should validate_uniqueness_of(:slug) }
    end
  end

  context 'top' do
    before do
      25.times do |i|
        create(:topic, count: i)
      end
    end

    it "returns the top 20 topics" do
      Topic.top.count.should == 20
      Topic.top.all? {|topic| topic.count >= 5 }.should be
    end
  end
end
