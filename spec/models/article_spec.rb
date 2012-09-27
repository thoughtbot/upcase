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

  context ".by_published" do
    before do
      create(:article, published_on: 30.days.ago)
      create(:article, published_on: 50.days.ago)
    end

    it "sorts by published_on desc" do
      Article.by_published.should == Article.all.sort_by { |a| a.published_on }.reverse
    end
  end

  context '.top' do
    before do
      25.times do |i|
        create :article, published_on: i.days.ago
      end
    end

    it 'returns the top 10 featured articles' do
      Article.top.count.should == 10
      Article.top.all? {|article| article.published_on >= 10.days.ago.to_date }.should be
    end
  end
end
