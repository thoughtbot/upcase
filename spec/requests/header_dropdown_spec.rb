require 'spec_helper'

describe 'Header Dropdown' do
  context 'GET /products' do
    it 'lists all public workshops' do
      workshop_one = create(:workshop)
      workshop_two = create(:workshop)
      private_workshop = create(:private_workshop)

      visit workshop_path(workshop_one)

      within header_container do
        expect(page).to have_content(workshop_one.name)
        expect(page).to have_content(workshop_two.name)
        expect(page).not_to have_content(private_workshop.name)

        click_link workshop_one.name

        expect(current_path).to eq(workshop_path(workshop_one))
      end
    end

    it 'lists all books' do
      book_one = create(:book_product)
      book_two = create(:book_product)
      inactive_book = create(:book_product, active: false)

      visit product_path(book_one)

      within header_container do
        expect(page).to have_content(book_one.name)
        expect(page).to have_content(book_two.name)
        expect(page).not_to have_content(inactive_book.name)

        click_link book_one.name

        expect(current_path).to eq(product_path(book_one))
      end
    end

    it 'lists all videos' do
      video_one = create(:video_product)
      video_two = create(:video_product)
      inactive_video = create(:video_product, active: false)

      visit product_path(video_one)

      within header_container do
        expect(page).to have_content(video_one.name)
        expect(page).to have_content(video_two.name)
        expect(page).not_to have_content(inactive_video.name)

        click_link video_one.name

        expect(current_path).to eq(product_path(video_one))
      end
    end

    it 'lists the topics' do
      topic_one = create(:topic, featured: true)
      topic_two = create(:topic, featured: true)
      not_featured_topic = create(:topic, featured: false)

      visit topic_path(topic_one)

      within header_container do
        expect(page).to have_content(topic_one.name)
        expect(page).to have_content(topic_two.name)
        expect(page).not_to have_content(not_featured_topic.name)
      end
    end
  end

  def header_container
    '.header-container nav'
  end
end
