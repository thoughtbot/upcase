Then /^I should see the article$/ do
  article = Topic.last!.articles.last!
  page.should have_content(article.title)
end

Given /^an article for topic "([^"]*)"$/ do |topic_name|
  topic = Topic.find_by_name(topic_name)
  topic.articles << create(:article)
end
