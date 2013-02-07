require 'spec_helper'

describe 'Articles' do
  context 'index' do
    it 'displays only the articles for the requested topic' do
      featured_topic = create(:topic, featured: true, name: "Topic 1")
      article = create(:article)
      featured_topic.articles << article
      other_article = create(:article)

      visit root_url
      click_link 'Topic 1'
      click_link 'View all Topic 1 articles'

      expect(page).to have_content(article.title)
      expect(page).not_to have_content(other_article.title)
    end

    it 'links external articles and indicates subscription articles' do
      topic = create(:topic)
      article = create(:article)
      tumblr_article = create(:article, external_url: 'http://example.com')
      topic.articles << article
      topic.articles << tumblr_article

      visit topic_articles_url(topic)

      expect(page).not_to have_css("a[href='#{article_path(tumblr_article)}']")
      expect(page).to have_css("a[href='#{tumblr_article.external_url}']")
      expect(page).to have_css("a[href='#{article_path(article)}']")
      expect(page).not_to have_css("#article_#{tumblr_article.id}", text: I18n.t('shared.subscribers_only_icon'))
      expect(page).to have_css("#article_#{article.id}", text: I18n.t('shared.subscribers_only_icon'))
    end
  end

  context 'show' do
    it 'displays the given article' do
      article = create(:article)
      sign_in_as_user_with_subscription

      visit article_url(article)

      expect(page).to have_content(article.title)
      expect(page.find('.body').native.inner_html).to include article.body_html
      expect(page).to have_content(article.published_on.to_s(:simple))
      expect(page).to have_css("meta[name='Description'][content='#{article.title}']")
    end

    it 'displays the related topics, products and workshops' do
      topic = create(:topic, name: 'Ruby')
      unrelated_topic = create(:topic, name: 'ASP.net')

      ruby_article = create(:article)
      topic.articles << ruby_article
      ruby_product = create(:product)
      topic.products << ruby_product
      ruby_workshop = create(:workshop)
      topic.workshops << ruby_workshop
      private_workshop = create(:workshop, public: false)
      topic.workshops << private_workshop

      unrelated_product = create(:product)
      unrelated_topic.products << unrelated_product
      unrelated_workshop = create(:workshop)
      unrelated_topic.workshops << unrelated_workshop
      sign_in_as_user_with_subscription

      visit article_url(ruby_article)

      expect(page).to have_content(topic.name)
      expect(page).to have_content(ruby_product.name)
      expect(page).to have_content(ruby_workshop.name)
      expect(page).to have_css('meta[name="Keywords"][content="Ruby"]')

      expect(page).not_to have_content(unrelated_topic.name)
      expect(page).not_to have_content(unrelated_product.name)
      expect(page).not_to have_content(unrelated_workshop.name)
      expect(page).not_to have_content(private_workshop.name)
    end
  end
end
