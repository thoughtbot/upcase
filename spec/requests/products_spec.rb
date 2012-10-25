require 'spec_helper'

describe 'Products' do
  context 'GET /products' do
    it 'lists all public courses' do
      course_one = create(:course)
      course_two = create(:course)
      private_course = create(:private_course)
      visit products_path
      expect(page).to have_content(course_one.name)
      expect(page).to have_content(course_two.name)
      expect(page).not_to have_content(private_course.name)
      click_link course_one.name
      expect(current_path).to eq(course_path(course_one))
    end

    it 'lists all books' do
      book_one = create(:book_product)
      book_two = create(:book_product)
      visit products_path
      expect(page).to have_content(book_one.name)
      expect(page).to have_content(book_two.name)
      click_link book_one.name
      expect(current_path).to eq(product_path(book_one))
    end

    it 'lists all videos' do
      video_one = create(:video_product)
      video_two = create(:video_product)
      visit products_path
      expect(page).to have_content(video_one.name)
      expect(page).to have_content(video_two.name)
      click_link video_one.name
      expect(current_path).to eq(product_path(video_one))
    end

    it 'lists all workshops' do
      workshop_one = create(:workshop_product)
      workshop_two = create(:workshop_product)
      visit products_path
      expect(page).to have_content(workshop_one.name)
      expect(page).to have_content(workshop_two.name)
      click_link workshop_one.name
      expect(current_path).to eq(product_path(workshop_one))
    end
  end
end
