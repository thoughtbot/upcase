require 'spec_helper'

describe Playbook::Page do
  let (:path) { Rails.root.join('spec/fixtures/playbook/getting-started/customer-discovery/index.html') }
  let (:page) { Playbook::Page.new(path) }

  describe '#content' do
    it 'returns the content of the page' do
      page.content.should include('The riskiest thing a company can do is make something no one wants.')
    end
  end

  describe '#title' do
    it 'returns the page title' do
      page.title.should == 'The Playbook : Customer discovery'
    end
  end

  describe '#topics' do
    it 'contains the topics in the page keywords' do
      topic = create(:topic, name: 'customer discovery')
      page.topics.should include(topic)
    end

    it 'contains playbook by default' do
      page.topics.should include(Topic.find_by_name('playbook'))
    end
  end
end
