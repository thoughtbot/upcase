Then /^I should see the article$/ do
  article = Topic.last!.articles.last!
  page.should have_content(article.title)
end

Given /^an article for topic "([^"]*)"$/ do |topic_name|
  topic = Topic.find_by_name(topic_name)
  topic.articles << create(:article)
end

Given /^a future article "([^"]*)" for topic "([^"]*)"$/ do |title, topic_name|
  topic = Topic.find_by_name(topic_name)
  topic.articles << create(:article, title: title, published_on: 7.days.from_now)
end
