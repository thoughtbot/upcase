Given /^there is a topic$/ do
  FactoryGirl.create(:topic)
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
