require 'spec_helper'

describe ApplicationHelper, '#mentor_image' do
  include Gravatarify::Helper

  it 'returns an image with a gravatar' do
    mentor = stub('mentor', email: 'someone@example.com')

    mentor_image = helper.mentor_image(mentor)

    expect(mentor_image).to include gravatar_url('someone@example.com')
  end
end
