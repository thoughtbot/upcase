require 'spec_helper'

describe Article do
  context 'associations' do
    it { should belong_to(:author) }
    it { should have_many(:classifications) }
    it { should have_many(:topics).through(:classifications) }
  end

  context 'validations' do
    it { should validate_presence_of(:body_html) }
    it { should validate_presence_of(:published_on) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:tumblr_url) }
  end
end
