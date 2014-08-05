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
    it 'is the number of validations' do
      trail_map = FakeTrailMap.new.trail
      trail = build(:trail, trail_map: trail_map)

      expect(trail.total).to eq 1
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
      expect(trail.trail_map).to eq FakeTrailMap.new.trail
    end

    it "populates the topic's summary with the trail's description" do
      topic = create(:topic, summary: 'old summary')
      trail = create(:trail, topic: topic)

      trail.import

      expect(topic.reload.summary).to eq "Description of Git"
    end

    it "populates the topic's name with the trail's name" do
      topic = create(:topic, name: 'old name')
      trail = create(:trail, topic: topic)

      trail.import

      expect(topic.reload.name).to eq "Git"
    end

    it 'leaves the existing trail map alone and notifies Airbrake when there is a json error' do
      Airbrake.stubs(:notify)
      exception = JSON::ParserError.new("JSON::ParserError")
      JSON.stubs(:parse).raises(exception)

      topic = create(:topic, summary: 'old summary')
      trail = create(:trail, trail_map: {'name' => 'old name', 'description' => 'old summary', 'old' => true}, topic: topic)

      trail.import
      topic.reload

      expect(Airbrake).to have_received(:notify).with(exception)
      expect(trail.trail_map["old"]).to eq true
      expect(topic.summary).to eq "old summary"
    end

    it 'does not update trail map if there is a non-200 http response' do
      Curl.stubs(get: stub(response_code: 'not 200', body_str: FakeTrailMap.new.trail.to_json))
      topic = create(:topic, summary: 'old summary', name: 'old name', slug: 'old+name')
      trail = create(:trail, topic: topic, trail_map: {'name' => 'old name', 'description' => 'old summary'})

      trail.import

      topic.reload
      expect(topic.summary).to eq "old summary"
      expect(topic.name).to eq "old name"
    end
  end

  context '#import with prerequisites' do
    before do
      fake_trail_map = FakeTrailMap.new
      fake_trail_map.prerequisites = ['exists', 'doesnotexist']
      fake_body_str = fake_trail_map.trail.to_json
      Curl.stubs(get: stub(body_str: fake_body_str, response_code: 200))
    end

    it 'associates the topic that exists' do
      related_topic = create(:topic, name: 'Exists', slug: 'exists')
      trail = create(:trail, slug: 'fake-trail')

      trail.import

      expect(trail.topic.topics).to eq [related_topic]
    end
  end

  context '#contribute_url' do
    it 'returns the correct url based on slug' do
      trail = Trail.new
      trail.slug = 'ruby-on-rails'
      expect(trail.contribute_url).to eq(
        "https://github.com/thoughtbot/trail-map/blob/master/trails/ruby-on-rails.json"
      )
    end
  end

  context '#steps' do
    it 'returns an array of steps' do
      trail_map = FakeTrailMap.new.trail
      trail = build(:trail, trail_map: trail_map)

      expect(trail.steps.size).to eq 1
      expect(trail.steps.first).to eq Step.new(trail_map['steps'].first)
    end
  end

  context '#resources_and_validations' do
    it 'returns resources and validations for all steps' do
      trail = create(:trail, trail_map: FakeTrailMap.new.trail)

      expect(trail.resources_and_validations.size).to eq 2
    end

    it 'returns an array when a step has no resources or validations' do
      trail_without_resources = FakeTrailMap.new.trail
      trail_without_resources['steps'].first.delete('resources')
      trail_without_resources['steps'].first.delete('validations')

      trail = create(:trail, trail_map: trail_without_resources)

      expect(trail.resources_and_validations).to eq []
    end
  end

  context '#reference' do
    it 'returns reference resources for the trail' do
      trail = create(:trail, trail_map: FakeTrailMap.new.trail)

      expect(trail.reference.size).to eq 1
    end

    it 'returns an empty array when a trail has no references' do
      trail_without_reference = FakeTrailMap.new.trail
      trail_without_reference.delete('reference')

      trail = create(:trail, trail_map: trail_without_reference)

      expect(trail.reference).to be_empty
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
