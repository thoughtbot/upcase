require 'spec_helper'

describe ArticlesController do
  context 'show' do
    it 'redirects to the tumblr url if the article has one' do
      article = create(:tumblr_article, external_url: 'http://example.com')
      get :show, id: article.to_param
      expect(response.code).to eq '301'
      expect(response.location).to eq article.external_url
    end

    context 'for a local article' do
      it 'redirects to the subscribe page if a visitor is not logged in' do
        sign_out

        expect_get_show_to_redirect_to_subscription_product
      end

      it 'redirects to the subscribe page if the user is not a subscriber' do
        user = create(:user)
        user.stubs(:has_active_subscription? => false)
        sign_in_as user

        expect_get_show_to_redirect_to_subscription_product
      end

      def expect_get_show_to_redirect_to_subscription_product
        article = create(:article)
        subscription_product = create(:subscribeable_product)

        get :show, id: article.to_param

        expect(response).to redirect_to product_path(subscription_product)
        expect(flash[:notice]).to include I18n.t('shared.subscriptions.protected_content')
      end
    end
  end
end
