class UpdateExplorableTopics < ActiveRecord::Migration[4.2]
  def change
    other_topic = Topic.find_by(slug: "other")
    other_topic&.update(explorable: false)
  end
end
