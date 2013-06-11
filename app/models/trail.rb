class Trail < ActiveRecord::Base
  belongs_to :topic

  validates :topic_id, :slug, presence: true

  serialize :trail_map, Hash

  def self.import
    find_each do |trail|
      trail.import
    end
  end

  def contribute_url
    "https://github.com/thoughtbot/trail-map/blob/master/trails/#{slug}.json"
  end

  def import
    http = Curl.get(github_url)
    if http.response_code == 200
      begin
        parse_and_assign_trail_map(http.body_str)
        assign_topic_attributes_from_trail_map
        self.topic.save!
        save!
      rescue JSON::ParserError => e
        Airbrake.notify(e)
      end
    end
  end

  def name
    trail_map['name']
  end

  def total
    count = 0
    steps.each do |step|
      count += step['resources'].length if step['resources']
      count += step['validations'].length if step['validations']
    end
    count
  end

  def steps
    trail_map['steps']
  end

  private

  def github_url
    "https://raw.github.com/thoughtbot/trail-map/master/trails/#{slug}.json"
  end

  def parse_and_assign_trail_map(raw_trail_map)
    self.trail_map = JSON.parse(raw_trail_map)
  end

  def assign_topic_attributes_from_trail_map
    self.topic.summary = trail_map['description']
    self.topic.name = trail_map['name']
    if trail_map['prerequisites'].present?
      trail_map['prerequisites'].each do |related|
        p "#{trail_map['name']}: looking for prerequisites: #{related}"
        prerequisite_topic = Topic.find_by_slug(related)
        unless self.related_topics.include?(prerequisite_topic)
          self.topic.related_topics << prerequisite_topic
        end
      end
    end
  end
end
