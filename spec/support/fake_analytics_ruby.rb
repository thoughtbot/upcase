class FakeAnalyticsRuby
  attr_reader :tracked_events

  def initialize
    @identified_events = EventsList.new([])
    @tracked_events = EventsList.new([])
  end

  def identify(options)
    @identified_events << options
  end

  def track(options)
    @tracked_events << options
  end

  def identified_events_for(user)
    @identified_events.events_for(user)
  end

  def tracked_events_for(user)
    @tracked_events.events_for(user)
  end

  class EventsList
    def initialize(events)
      @events = events
    end

    def <<(event)
      @events << event
    end

    def events_for(user)
      self.class.new(
        events.select do |event|
          event[:user_id] == user.id
        end
      )
    end

    def named(event_name)
      self.class.new(
        events.select do |event|
          event[:event] == event_name
        end
      )
    end

    def has_properties?(options)
      events.any? do |event|
        options.all? do |key, value|
          (event[:properties] || event[:traits])[key] == value
        end
      end
    end

    def empty?
      events.empty?
    end

    private

    attr_reader :events
  end
end
