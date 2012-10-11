require 'spec_helper'

describe Topic do
  # Associations
  it { should have_many(:articles).through(:classifications) }
  it { should have_many(:classifications) }
  it { should have_many(:courses).through(:classifications) }
  it { should have_many(:products).through(:classifications) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }

  context '.create' do
    before do
      @topic = create(:topic, name: ' Test Driven Development ')
    end

    it 'generates a stripped, url encoded slug based on name' do
      @topic.slug.should == 'test+driven+development'
    end
  end

  context '.top' do
    before do
      25.times do |i|
        create :topic, count: i, featured: true
      end
    end

    it 'returns the top 20 featured topics' do
      Topic.top.count.should == 20
      Topic.top.all? {|topic| topic.count >= 5 }.should be
    end
  end

  context 'validations' do
    context 'uniqueness' do
      before do
        create :topic
      end

      it { should validate_uniqueness_of(:slug) }
    end
  end

  context '.import_trail_map' do
    let(:fake_trail) do
      fake_trail = {
        'name' => 'Fake Trail',
        'steps' => [
          {
            'name' => 'Critical Learning',
            'resources' => [
              {
                'name' => 'Google',
                'url' => 'http://lmgtfy.com/'
              }
            ]
          }
        ]
      }
    end
    before(:all) do
      fake_body_str = fake_trail.to_json
      Curl.stubs(get: stub(body_str: fake_body_str))
    end

    it 'downloads a trail and parrots it back' do
      topic = create(:topic, name: 'fake-trail')
      topic.import_trail_map
      topic.trail_map.should == fake_trail
    end
  end
end
