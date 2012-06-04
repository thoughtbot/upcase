Then /^I should see the topic$/ do
  topic = Topic.last
  page.should have_selector('li h2', text: topic.name)
  page.should have_selector('li p', text: topic.summary)
end

Given /^a related article exists$/ do
  topic = Topic.last
  article = create(:article)
  topic.articles << article
end

Then /^I should see the topic page$/ do
  topic = Topic.last
  page.should have_selector('title', text: topic.name)
  page.should have_css(%{meta[name='keywords'][content='#{topic.keywords}']})
  page.should have_css(%{meta[name='description'][content='#{topic.summary}']})
  page.should have_selector('h1', text: topic.name)
  page.should have_selector('p', text: topic.body_html)
end

And /^I should see the related article$/ do
  articles = all 'section.post h2 a'
  articles.should_not be_empty

  articles.each do |link|
    link[:href].should match(%r{^http://robots\.thoughtbot\.com})
  end
end

Then /^I search for "(.*?)"$/ do |word|
  fill_in "search", with: word
end
