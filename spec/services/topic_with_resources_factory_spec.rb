require "rails_helper"

describe TopicWithResourcesFactory do
  describe "#decorate" do
    it "decorates a topic with resources" do
      topic = create(:topic)
      other_topic = create(:topic)
      resources = [
        create(:exercise, title: "exercise-one"),
        create(:video, :published, title: "video-one"),
        create(:video_tutorial, name: "video_tutorial-one"),
      ]
      resources.each do |classifiable|
        topic.classifications.create!(classifiable: classifiable)
      end
      other_resource = create(:exercise, title: "exercise-two")
      other_topic.classifications.create!(classifiable: other_resource)
      factory = TopicWithResourcesFactory.new(catalog: Catalog.new)

      decorated = factory.decorate(topic)

      expect(decorated.name).to eq(topic.name)
      expect(decorated.resources).to match_array(resources)
    end
  end
end
