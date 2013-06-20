require 'spec_helper'

describe 'Bytes' do
  context 'index' do
    it 'displays bytes' do
      byte = create(:byte)
      draft = create(:byte, draft: true)

      visit bytes_path

      expect(page).not_to have_css("a[href='#{byte_path(draft)}']")
      expect(page).to have_css("a[href='#{byte_path(byte)}']")
    end
  end

  context 'show' do
    it 'displays the given byte' do
      byte = create(:byte)
      sign_in_as_user_with_subscription

      visit byte_url(byte)

      expect(page).to have_content(byte.title)
      expect(page.find('.body').native.inner_html).to include byte.body_html
      expect(page).to have_content(byte.published_on.to_s(:simple))
      expect(page).to have_css("meta[name='Description'][content='#{byte.title}']")
    end

    it 'displays the related topics, products and workshops' do
      topic = create(:topic, name: 'Ruby')
      unrelated_topic = create(:topic, name: 'ASP.net')

      ruby_byte = create(:byte)
      topic.bytes << ruby_byte
      ruby_product = create(:product)
      topic.products << ruby_product
      ruby_workshop = create(:workshop)
      topic.workshops << ruby_workshop
      private_workshop = create(:workshop, active: false)
      topic.workshops << private_workshop

      unrelated_product = create(:product)
      unrelated_topic.products << unrelated_product
      unrelated_workshop = create(:workshop)
      unrelated_topic.workshops << unrelated_workshop
      sign_in_as_user_with_subscription

      visit byte_url(ruby_byte)

      expect(page).to have_css('meta[name="Keywords"][content="Ruby"]')
      within '.content' do
        expect(page).to have_content(topic.name)
        expect(page).to have_content(ruby_product.name)
        expect(page).to have_content(ruby_workshop.name)

        expect(page).not_to have_content(unrelated_topic.name)
        expect(page).not_to have_content(unrelated_product.name)
        expect(page).not_to have_content(unrelated_workshop.name)
        expect(page).not_to have_content(private_workshop.name)
      end
    end
  end
end
