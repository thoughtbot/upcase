require 'spec_helper'

describe Show do
  it { should have_many(:episodes) }

  it { should validate_presence_of(:credits) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:itunes_url) }
  it { should validate_presence_of(:keywords) }
  it { should validate_presence_of(:short_description) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:title) }

  it 'has a to_param of the slug' do
    show = create(:show, slug: 'slug')

    expect(show.to_param).to eq 'slug'
  end

  it 'has a short title' do
    show = build(:show, title: 'Giant Robots Smashing into other Giant Robots')

    expect(show.short_title).to eq 'Giant Robots'
  end
end
