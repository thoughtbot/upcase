require 'spec_helper'

describe Trail do
  it { should belong_to(:topic) }

  it { should validate_presence_of(:topic_id) }
  it { should validate_presence_of(:slug) }

  it "gets its name from the trail map" do
    trail_map = FakeTrailMap.new.trail
    trail = build(:trail, trail_map: trail_map)

    expect(trail.name).to eq 'Git'
  end

  context '#total' do
    it 'is the number of resources and validations' do
      trail_map = FakeTrailMap.new.trail
      trail = build(:trail, trail_map: trail_map)

      expect(trail.total).to eq 2
    end
  end

  context '#import' do
    before do
      fake_body_str = FakeTrailMap.new.trail.to_json
      Curl.stubs(get: stub(body_str: fake_body_str, response_code: 200))
    end

    it 'downloads a trail and stores it' do
      trail = create(:trail, slug: 'fake-trail')
      trail.import
      trail.trail_map.should == FakeTrailMap.new.trail
    end

    it "populates the topic's summary with the trail's description" do
      topic = create(:topic, summary: 'old summary')
      trail = create(:trail, topic: topic)

      trail.import

      topic.reload.summary.should == 'Description of Git'
    end

    it "populates the topic's name with the trail's name" do
      topic = create(:topic, name: 'old name')
      trail = create(:trail, topic: topic)

      trail.import

      topic.reload.name.should == 'Git'
    end

    it 'leaves the existing trail map alone and notifies Airbrake when there is a json error' do
      Airbrake.stubs(:notify)
      exception = JSON::ParserError.new("JSON::ParserError")
      JSON.stubs(:parse).raises(exception)

      topic = create(:topic, summary: 'old summary')
      trail = create(:trail, trail_map: {'name' => 'old name', 'description' => 'old summary', 'old' => true}, topic: topic)

      trail.import
      topic.reload

      Airbrake.should have_received(:notify).with(exception)
      trail.trail_map["old"].should == true
      topic.summary.should == 'old summary'
    end

    it 'does not update trail map if there is a non-200 http response' do
      Curl.stubs(get: stub(response_code: 'not 200', body_str: FakeTrailMap.new.trail.to_json))
      topic = create(:topic, summary: 'old summary', name: 'old name', slug: 'old+name')
      trail = create(:trail, topic: topic, trail_map: {'name' => 'old name', 'description' => 'old summary'})

      trail.import

      topic.reload
      topic.summary.should == 'old summary'
      topic.name.should == 'old name'
    end
  end

  context '#contribute_url' do
    it 'returns the correct url based on slug' do
      trail = Trail.new
      trail.slug = 'ruby-on-rails'
      trail.contribute_url.should eq 'https://github.com/thoughtbot/trail-map/blob/master/trails/ruby-on-rails.json'
    end
  end

  context '#resources_and_validations' do
    it 'returns resources and validations for all steps' do
      trail = create(:trail, trail_map: FakeTrailMap.new.trail)

      expect(trail.resources_and_validations.size).to eq 2
    end
  end

  context '.all_resources_and_validations' do
    it 'returns resources and validations across all trails' do
      fake_trail_map = FakeTrailMap.new
      trail1 = create(:trail, trail_map: fake_trail_map.trail)
      trail2 = create(:trail, trail_map: fake_trail_map.trail)
      total_trail_items = trail1.total + trail2.total

      expect(Trail.all_resources_and_validations.size).to eq total_trail_items
    end
  end

  context '.import' do
    it 'imports each trail' do
      trail = create(:trail, trail_map: { hello: 'world' })
      Curl.stubs(get: stub(body_str: FakeTrailMap.new.trail.to_json, response_code: 200))

      expect(trail.trail_map).not_to eq FakeTrailMap.new.trail

      Trail.import

      expect(trail.reload.trail_map).to eq FakeTrailMap.new.trail
    end
  end
end
