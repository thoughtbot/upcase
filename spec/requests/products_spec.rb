require 'spec_helper'

describe 'Products' do
  context 'GET /products' do
    it 'lists all public workshops' do
      workshop_one = create(:workshop)
      workshop_two = create(:workshop)
      private_workshop = create(:private_workshop)
      visit products_path
      expect(page).to have_content(workshop_one.name)
      expect(page).to have_content(workshop_two.name)
      expect(page).not_to have_content(private_workshop.name)
      click_link workshop_one.name
      expect(current_path).to eq(workshop_path(workshop_one))
    end

    it 'lists all books' do
      book_one = create(:book_product)
      book_two = create(:book_product)
      inactive_book = create(:book_product, active: false)
      visit products_path
      expect(page).to have_content(book_one.name)
      expect(page).to have_content(book_two.name)
      expect(page).not_to have_content(inactive_book.name)
      click_link book_one.name
      expect(current_path).to eq(product_path(book_one))
    end

    it 'lists all videos' do
      video_one = create(:video_product)
      video_two = create(:video_product)
      inactive_video = create(:video_product, active: false)
      visit products_path
      expect(page).to have_content(video_one.name)
      expect(page).to have_content(video_two.name)
      expect(page).not_to have_content(inactive_video.name)
      click_link video_one.name
      expect(current_path).to eq(product_path(video_one))
    end

    it 'lists all workshops' do
      workshop_one = create(:workshop_product)
      workshop_two = create(:workshop_product)
      inactive_workshop = create(:workshop_product, active: false)
      visit products_path
      expect(page).to have_content(workshop_one.name)
      expect(page).to have_content(workshop_two.name)
      expect(page).not_to have_content(inactive_workshop.name)
      click_link workshop_one.name
      expect(current_path).to eq(product_path(workshop_one))
    end
  end
end
