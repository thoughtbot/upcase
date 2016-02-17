class TrailTracker
  def initialize(trail)
    @trail = trail
  end

  def started_events
    [
      [
        "Started trail",
        {
          name: trail.name,
        },
      ],
    ]
  end

  def finished_events
    [
      [
        "Finished trail",
        {
          name: trail.name,
        },
      ],
    ]
  end

  private

  attr_reader :trail
end
