require 'spec_helper'

describe Article do
  context 'associations' do
    it { should have_many(:classifications) }
    it { should have_many(:topics).through(:classifications) }
    it { should have_many(:products).through(:topics) }
    it { should have_many(:workshops).through(:topics) }
  end

  context 'validations' do
    it { should validate_presence_of(:body_html) }
    it { should validate_presence_of(:published_on) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:external_url) }
  end

  it_behaves_like 'it has related items'

  context ".ordered" do
    before do
      create(:article, published_on: 30.days.ago)
      create(:article, published_on: 50.days.ago)
    end

    it "sorts by published_on desc" do
      Article.ordered.should == Article.all.sort_by { |a| a.published_on }.reverse
    end
  end

  context 'to_param' do
    it 'is the id and the parameterized title' do
      article = create(:article, title: 'Test Title')
      expect(article.to_param).to eq "#{article.id}-test-title"
    end
  end

  context 'keywords' do
    it 'gives a comma separated list of topics' do
      article = create(:article)
      topic = create(:topic)
      topic.articles << article
      topic_two = create(:topic)
      topic_two.articles << article

      expect(article.keywords).to eq "#{topic.name},#{topic_two.name}"
    end
  end
end
