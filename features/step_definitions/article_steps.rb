Then /^I should see the article$/ do
  article = Topic.last!.articles.last!
  page.should have_content(article.title)
end
