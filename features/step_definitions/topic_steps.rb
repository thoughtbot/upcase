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

Then /^the related reading section should include the article\.$/ do
  article = Topic.last!.articles.first!
  page.find("#article_#{article.id}").should have_content(article.title)
end
