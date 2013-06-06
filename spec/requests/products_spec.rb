require 'spec_helper'

describe 'Products' do
  context 'GET /products' do
    it 'lists all active workshops' do
      workshop_one = create(:workshop)
      workshop_two = create(:workshop)
      private_workshop = create(:private_workshop)

      visit products_path

      expect(page).to have_content(workshop_one.name)
      expect(page).to have_content(workshop_two.name)
      expect(page).not_to have_content(private_workshop.name)
    end

    it 'lists all books' do
      book_one = create(:book_product, :active)
      book_two = create(:book_product, :active)
      inactive_book = create(:book_product, :inactive)

      visit products_path

      expect(page).to have_css("img[alt='#{book_one.name} cover']")
      expect(page).to have_css("img[alt='#{book_two.name} cover']")
      expect(page).not_to have_css("img[alt='#{inactive_book.name} cover']")
    end

    it 'lists all videos' do
      video_one = create(:video_product)
      video_two = create(:video_product)
      inactive_video = create(:video_product, active: false)

      visit products_path

      expect(page).to have_content(video_one.name)
      expect(page).to have_content(video_two.name)
      expect(page).not_to have_content(inactive_video.name)
    end

    it 'lists the local articles' do
      article_one = create(:article)
      article_two = create(:article)
      tumblr_article = create(:tumblr_article)

      visit products_path

      expect(page).to have_content(article_one.title)
      expect(page).to have_content(article_two.title)
      expect(page).not_to have_content(tumblr_article.title)
    end
  end
end
