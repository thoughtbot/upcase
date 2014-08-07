require "rails_helper"

describe MentorHelper, type: :helper do
  describe '#mentor_image' do
    include Gravatarify::Helper

    it 'returns an image with a gravatar' do
      mentor = stub('mentor', email: 'someone@example.com')

      mentor_image_tag = helper.mentor_image(mentor)

      expect(mentor_image_tag).to include gravatar_url('someone@example.com')
    end

    it 'returns an image whose src uses https' do
      mentor = stub('mentor', email: 'someone@example.com')

      mentor_image_tag = helper.mentor_image(mentor)

      expect(mentor_image_tag).to include 'https'
    end
  end

  describe '#mentor_contact_link' do
    it 'returns a mailto link for the mentor' do
      mentor = stub('mentor',
                    email: 'bob@thoughtbot.com',
                    first_name: 'Bob')
      anchor_text = I18n.t('dashboards.show.contact_your_mentor',
                           mentor_name: mentor.first_name)

      result = helper.mentor_contact_link(mentor)
      expect(result).to eq "<a href=\"mailto:#{mentor.email}\">#{anchor_text}</a>"
    end
  end
end
