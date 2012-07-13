require 'spec_helper'

describe Topic do
  context 'associations' do
    it { should have_many(:classifications) }
    it { should have_many(:articles).through(:classifications) }
    it { should have_many(:products).through(:classifications) }
    it { should have_many(:courses).through(:classifications) }
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

  context 'search' do
    let!(:rails) { create(:topic, name: "Rails") }
    let!(:ruby) { create(:topic, name: "Ruby") }
    let!(:testing) { create(:topic, name: "ruby on rails") }

    it "returns only all matching topics" do
      results = Topic.search("r")
      results.should =~ [rails, ruby]
    end

    it "returns one matching topic if matched exactly" do
      results = Topic.search("rails")
      results.should == [rails]
    end

    it "returns nothing if no matches" do
      Topic.search("gh").should be_empty
    end
  end
end
