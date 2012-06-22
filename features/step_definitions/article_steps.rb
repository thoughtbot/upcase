Given 'there is an article' do
  create(:article, 
         title: 'test', 
         body_html: '<b>body</b>',
         tumblr_url: 'http://tumblr.com',
         published_on: Date.parse('2012-01-07'))
end

Then 'I see the article' do
  article = Article.find_by_title!('test')
  article_selector = "##{dom_id(article)}.result"
  page.should have_css(article_selector)
  within article_selector do
    page.should have_css(".excerpt", text: "body")
    page.should have_css(".results-date", text: article.published_on.to_time.to_s(:short_date))
  end
end

Then 'I should not see the article' do
  article = Article.find_by_title!('test')
  article_selector = "##{dom_id(article)}.result"
  page.should_not have_css(article_selector)
end
