require 'spec_helper'

describe 'Articles' do
  context 'index' do
    it 'displays only the articles for the requested topic' do
      featured_topic = create(:topic, featured: true, name: "Topic 1")
      article = create(:article)
      featured_topic.articles << article
      other_article = create(:article)

      visit topic_path(featured_topic)
      click_link 'View related Giant Robots articles'

      expect(page).to have_content(article.title)
      expect(page).not_to have_content(other_article.title)
      expect(page).not_to have_content('Back to Trail')
    end

    it 'links external articles' do
      topic = create(:topic)
      article = create(:article)
      topic.articles << article

      visit topic_articles_url(topic)

      expect(page).to have_css("a[href='#{article.external_url}']")
    end
  end

  context 'show' do
    it 'displays a link back to the trail for topics with trails' do
      trail = create(:trail)
      topic = trail.topic
      article = create(:article)
      topic.articles << article

      visit topic_articles_path(topic)

      expect(page).to have_content('Back to Trail')
    end
  end
end
