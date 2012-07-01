Given /^there is a topic$/ do
  FactoryGirl.create(:topic)
end

Then /^I see the topic$/ do
  within ".popular" do
    page.should have_css("ul li a", text: Topic.first.name)
  end
end
