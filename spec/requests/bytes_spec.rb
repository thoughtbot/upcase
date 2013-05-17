require 'spec_helper'

describe 'Bytes' do
  context 'index' do
    it 'displays only published subscription articles', js: true do
      learn_byte = create(:article)
      byte_draft = create(:article, draft: true)
      tumblr_article = create(:article, external_url: 'http://example.com')

      visit bytes_path

      expect(page).not_to have_css("a[href='#{tumblr_article.external_url}']")
      expect(page).not_to have_css("a[href='#{article_path(byte_draft)}']")
      expect(page).to have_css("a[href='#{article_path(learn_byte)}']")
      expect(page).not_to have_selector('.subscription_icon', visible: true)
    end
  end
end
