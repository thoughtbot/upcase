require 'spec_helper'

describe Article do
  context 'associations' do
    it { should belong_to(:author) }
    it { should have_many(:classifications) }
    it { should have_many(:topics).through(:classifications) }
  end

  context 'validations' do
    it { should validate_presence_of(:body_html) }
    it { should validate_presence_of(:published_on) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:tumblr_url) }
  end

  context "#for_topics" do
    let(:article_in_topic) { create(:article) }
    let(:article_outside_topic) { create(:article) }
    let(:topic) { create(:topic) }

    before do
      article_in_topic.topics << topic
    end

    it "includes the article in the topic" do
      results = Article.for_topics([topic])
      results.should include article_in_topic
      results.should_not include article_outside_topic
    end
  end

  context "#by_published" do
    before do
      create(:article, published_on: 30.days.ago)
      create(:article, published_on: 50.days.ago)
    end

    it "sorts by published_on desc" do
      Article.by_published.should == Article.all.sort_by { |a| a.published_on }.reverse
    end
  end
end
