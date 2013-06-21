require 'spec_helper'

describe Topic do
  # Associations
  it { should have_many(:articles).through(:classifications) }
  it { should have_many(:bytes).through(:classifications) }
  it { should have_many(:classifications) }
  it { should have_many(:workshops).through(:classifications) }
  it { should have_many(:episodes).through(:classifications) }
  it { should have_many(:products).through(:classifications) }
  it { should have_many(:topics).through(:classifications) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }

  # Associations
  it { should allow_mass_assignment_of(:trail_map) }
  it { should allow_mass_assignment_of(:featured) }
  it { should allow_mass_assignment_of(:keywords) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:summary) }
  it { should allow_mass_assignment_of(:related_topic_ids) }

  it_behaves_like 'it has related items'

  context '.create' do
    before do
      @topic = create(:topic, name: ' Test Driven Development ')
    end

    it 'generates a stripped, url encoded slug based on name' do
      @topic.slug.should == 'test+driven+development'
    end
  end

  context 'self.top' do
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

  context 'self.featured' do
    it 'returns the featured topics' do
      normal = create(:topic, featured: false)
      featured = create(:topic, featured: true)
      Topic.featured.should include featured
      Topic.featured.should_not include normal
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
        'description' => 'Description of Fake Trail',
        'steps' => [
          {
            'name' => 'Critical Learning',
            'resources' => [
              {
                'title' => 'Google',
                'uri' => 'http://lmgtfy.com/'
              }
            ]
          }
        ]
      }
    end

    before do
      fake_body_str = fake_trail.to_json
      Curl.stubs(get: stub(body_str: fake_body_str, response_code: 200))
    end

    it 'downloads a trail and stores it' do
      topic = create(:topic, name: 'fake-trail')
      topic.import_trail_map
      topic.trail_map.should == fake_trail
    end

    it "populates the topic's summary with the trail's description" do
      topic = create(:topic, summary: 'old summary')
      topic.import_trail_map
      topic.summary.should == 'Description of Fake Trail'
    end

    it "populates the topic's name with the trail's name" do
      topic = create(:topic, name: 'old name')
      topic.import_trail_map
      topic.name.should == 'Fake Trail'
    end

    it 'leaves the existing trail map alone and notifies Airbrake when there is a json error' do
      Airbrake.stubs(:notify)
      exception = JSON::ParserError.new("JSON::ParserError")
      JSON.stubs(:parse).raises(exception)

      topic = create(:topic, summary: 'old summary', trail_map: {'old' => true})
      topic.import_trail_map

      Airbrake.should have_received(:notify).with(exception)
      topic.trail_map["old"].should == true
      topic.summary.should == 'old summary'
    end

    it 'does not update trail map if there is a non-200 http response' do
      Curl.stubs(get: stub(response_code: 'not 200', body_str: fake_trail.to_json))
      topic = create(:topic, summary: 'old summary', name: 'old name', slug: 'old+name')

      topic.import_trail_map

      topic.summary.should == 'old summary'
      topic.name.should == 'old name'
    end
  end

  context 'self.import_trail_maps' do
    it 'calls import_trail_map for each featured topic' do
      featured_topic = stub(:import_trail_map)
      featured = stub
      featured.stubs(:find_each).yields(featured_topic)
      Topic.stubs(:featured).returns(featured)

      Topic.import_trail_maps

      featured_topic.should have_received(:import_trail_map)
    end
  end

  context '#contribute_url' do
    it 'returns the correct url based on slug' do
      topic = Topic.new
      topic.slug = 'ruby+on+rails'
      topic.contribute_url.should eq 'https://github.com/thoughtbot/trail-map/blob/master/trails/ruby-on-rails.json'
    end
  end

  describe '#meta_keywords' do
    it 'returns a comma delimited string of topics' do
      create(:topic, name: 'Ruby')
      create(:topic, name: 'Rails')

      result = Topic.meta_keywords

      expect(result).to eq 'Ruby, Rails'
    end
  end
end
