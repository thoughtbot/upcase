class UpdateExplorableTopics < ActiveRecord::Migration
  def change
    other_topic = Topic.find_by(slug: "other")
    if other_topic
      other_topic.update(explorable: false)
    end
  end
end
