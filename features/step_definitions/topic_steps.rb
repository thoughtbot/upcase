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
  find_field("search_input").value.should == Topic.name
end
