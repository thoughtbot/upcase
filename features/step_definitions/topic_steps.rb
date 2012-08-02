Given /^there is a topic$/ do
  FactoryGirl.create(:topic)
end

Given /^there is a featured topic$/ do
  FactoryGirl.create(:topic, featured: true)
end

Then /^I see the topic$/ do
  within ".popular" do
    page.should have_css("ul li a", text: Topic.first.name)
  end
end

Then /^I see the page for the topic$/ do
  topic = Topic.first
  find_field("search_input").value.should == topic.name
  page.should have_css("h3", text: Article.all.first.title)
  page.should_not have_css("h3", text: Article.all.second.title)
  page.should have_css("li.product a h3", text: Product.all.first.name)
  page.should_not have_css("li.product a h3", text: Product.all.second.name)
  page.should have_css("li.course a h3", text: Course.all.first.name)
  page.should_not have_css("li.course a h3", text: Course.all.second.name)
  page.evaluate_script("$('.search-bar a.clear-search:visible').length").to_i.should > 0
end

Given /^there is an article for the topic$/ do
  topic = Topic.first
  topic.articles << FactoryGirl.create(:article)
end

Given /^there is an article for another topic$/ do
  topic = FactoryGirl.create(:topic)
  topic.articles << FactoryGirl.create(:article)
end

Given /^there is an product for the topic$/ do
  topic = Topic.first
  topic.products << FactoryGirl.create(:product, product_type: 'screencast')
end

Given /^there is an product for another topic$/ do
  topic = FactoryGirl.create(:topic)
  topic.products << FactoryGirl.create(:product, product_type: 'screencast')
end

Given /^there is a workshop for the topic$/ do
  topic = Topic.first
  topic.courses << FactoryGirl.create(:course)
end

Given /^there is a workshop for another topic$/ do
  topic = FactoryGirl.create(:topic)
  topic.courses << FactoryGirl.create(:course)
end

Given /^there is an article for "([^"]*)"$/ do |topic_name|
  topic = Topic.find_by_name(topic_name)
  article = FactoryGirl.create(:article)
  topic.articles << article
end

When /^I search for "([^"]*)"$/ do |text|
  fill_in "search_input", with: text
end

Then /^I should see the results for "([^"]*)"$/ do |topic_name|
  topic = Topic.find_by_name(topic_name)
  page.should have_css("li.#{topic.slug}")
end

Then /^I should not see the results for "([^"]*)"$/ do |topic_name|
  topic = Topic.find_by_name(topic_name)
  page.should_not have_css("li.#{topic.slug}")
end
