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
    parse_and_assign_trail_map
    assign_topic_attributes_from_trail_map
    topic.save!
    save!
  end

  def name
    trail_map['name']
  end

  def total
    steps.inject(0) do |count, step|
      count += step.validations.length if step.validations
      count
    end
  end

  def steps
    trail_map['steps'].map do |step_hash|
      Step.new(step_hash)
    end
  end

  def resources_and_validations
    items = steps.map do |step|
      step.validations << step.resources
    end
    items.flatten
  end

  def reference
    trail_map['reference'] || []
  end

  private

  def github_url
    "https://raw.github.com/thoughtbot/trail-map/master/trails/#{slug}.json"
  end

  def parse_and_assign_trail_map
    self.trail_map = fetch_trail_map
  end

  def fetch_trail_map
    http = Curl.get(github_url)
    parse_remote_trail_map(http) || trail_map
  end

  def parse_remote_trail_map(http)
    if http.response_code == 200
      JSON.parse(http.body_str)
    end
  rescue JSON::ParserError => e
    Airbrake.notify(e)
  end

  def assign_topic_attributes_from_trail_map
    self.topic.summary = trail_map['description']
    self.topic.name = trail_map['name']
    associate_trail_map_prerequisites
  end

  def associate_trail_map_prerequisites
    if trail_map['prerequisites'].present?
      trail_map['prerequisites'].each do |related_slug|
        find_and_associate_related_topic(related_slug)
      end
    end
  end

  def find_and_associate_related_topic(related_slug)
    related_topic = Topic.find_by_slug(related_slug)
    if add_related_topic?(related_topic)
      self.topic.topics << related_topic
    end
  end

  def add_related_topic?(related_topic)
    related_topic && !self.topic.topics.include?(related_topic)
  end
end
