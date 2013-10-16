require 'spec_helper'

describe ApplicationHelper, '#mentor_image' do
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
