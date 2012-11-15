require 'spec_helper'

describe 'episodes/index.xml.builder' do
  context 'rendered with 2 episodes' do
    before(:each) do
      @first = create(:episode, published_on: 1.day.ago, notes: '* A list')
      assign(:episodes, [@first, create(:episode, published_on: 2.days.ago)])
      render
      @xml = Nokogiri::XML.parse(rendered)
    end

    it 'includes the rss and channel node' do
      @xml.css('rss').length.should == 1
      @xml.css('channel').length.should == 1
    end

    it 'includes the podcast title' do
      @xml.css('channel title').first.text.should == 'Giant Robots Smashing into other Giant Robots'
    end

    it 'includes the podcast link' do
      url = 'http://thoughtbot.com/podcast'
      @xml.css('channel link').first['href'].should == url
    end

    it 'has an updated date of the most recently published episode' do
      @xml.css('channel pubDate').first.text.should == 1.day.ago.xmlschema.to_s
    end

    it 'includes both episodes' do
      @xml.css('channel item').length.should == 2
    end

    it 'includes the guid of the episode' do
      @xml.css('channel item guid').first.text.should == episode_url(@first)
    end

    it 'includes the full title for the episode' do
      @xml.css('channel item title').first.text.should == @first.full_title
    end

    it 'includes the date for the episode' do
      @xml.css('channel item pubDate').first.text.should == @first.published_on.xmlschema.to_s
    end

    it 'has the encoded content' do
      item = @xml.css('channel item').first
      content = item.at_xpath('content:encoded').text
      content.should include @first.description
      content.should include BlueCloth.new(@first.notes).to_html
    end
  end

  context 'rendered with an episode with an old url' do
    before(:each) do
      @first = create(:episode, published_on: 1.day.ago, old_url: 'http://ebay.com')
      assign(:episodes, [@first])
      render
      @xml = Nokogiri::XML.parse(rendered)
    end

    it 'includes the old url as the guid of the episode' do
      @xml.css('channel item guid').first.text.should == @first.old_url
    end
  end
end
