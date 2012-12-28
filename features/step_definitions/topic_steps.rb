Given /^a "([^"]*)" product named "([^"]*)" for topic "([^"]*)"$/ do |product_type, name, topic_name|
  topic = Topic.find_by_name(topic_name)
  topic.products << create(:product, name: name, product_type: product_type)
end

Given /^a "([^"]*)" inactive product named "([^"]*)" for topic "([^"]*)"$/ do |product_type, name, topic_name|
  topic = Topic.find_by_name(topic_name)
  topic.products << create(:product, name: name, product_type: product_type, active: false)
end

Given /^a course named "([^"]*)" for topic "([^"]*)"$/ do |name, topic_name|
  topic = Topic.find_by_name(topic_name)
  topic.courses << create(:course, name: name)
end

Given /^a featured topic named "([^"]*)"$/ do |name|
  create :topic, featured: true, name: name
end

Given /^a topic named "([^"]*)"$/ do |name|
  create :topic, name: name
end

Given /^an article for topic "([^"]*)"$/ do |topic_name|
  topic = Topic.find_by_name(topic_name)
  topic.articles << create(:article)
end

Given /^a podcast episode named "([^"]*)" for topic "([^"]*)"$/ do |title, topic_name|
  topic = Topic.find_by_name(topic_name)
  topic.episodes << create(:episode, title: title)
end

Then /^the related reading section should include the article\.$/ do
  article = Topic.last!.articles.first!
  page.find("#article_#{article.id}").should have_content(article.title)
end

Given /^a trail\-map for "([^""]*)"$/ do |topic_slug|
  topic = Topic.find_or_create_by_slug!(topic_slug)
  topic.trail_map = {
    "name" => topic_slug.humanize,
    "prerequisites" => [Topic.find_or_create_by_name("ruby").slug],
    "steps" => [{
      "name" => "Learn to Learn",
      "resources" => [{
        "title" => "Wikipedia",
        "uri" => "http://www.wikipedia.org/"
      }],
      "validations" => [
        "Rule the universe"
      ]
    }]
  }
  topic.save!
end

Then /^I should see a trail\-map for "([^""]*)"$/ do |topic_slug|
  topic = Topic.find_by_slug!(topic_slug)
  within('.text-box') do
    page.should have_content("Learn to Learn")
    page.should have_content("Resources")
    page.should have_content("Wikipedia")
    page.should have_content("You should be able to")
    page.should have_content("Rule the universe")
  end
end
