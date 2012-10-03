Given /^a topic named "([^"]*)"$/ do |name|
  create :topic, name: name
end

Given /^a featured topic named "([^"]*)"$/ do |name|
  create :topic, featured: true, name: name
end

Given /^an article for topic "([^"]*)"$/ do |topic_name|
  topic = Topic.find_by_name(topic_name)
  topic.articles << create(:article)
end

Given /^a course for topic "([^"]*)"$/ do |topic_name|
  topic = Topic.find_by_name(topic_name)
  topic.courses << create(:course)
end

Given /^a "([^"]*)" product for topic "([^"]*)"$/ do |product_type, topic_name|
  topic = Topic.find_by_name(topic_name)
  topic.products << create(:product, product_type: product_type)
end

Then /^the topic nav should include "([^"]*)"$/ do |text|
  optional = ['WORKSHOPS', 'BOOKS', 'VIDEOS', 'BLOG POSTS']
  optional.delete text

  page.find('#learn-detail-nav').should have_content('TRAIL MAP')
  page.find('#learn-detail-nav').should have_content(text)

  optional.each do |content|
    page.find('#learn-detail-nav').should_not have_content(content)
  end
end
