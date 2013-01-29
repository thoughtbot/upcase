require 'spec_helper'

describe ArticlesController do
  context 'show' do
    it 'redirects to the tumblr url if the article has one' do
      article = create(:tumblr_article, tumblr_url: 'http://example.com')
      get :show, id: article.to_param
      expect(response.code).to eq '301'
      expect(response.location).to eq article.tumblr_url
    end
  end
end
