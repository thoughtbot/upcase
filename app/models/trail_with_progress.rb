class TrailWithProgress < SimpleDelegator
  delegate :unstarted?, :in_progress?, :complete?, to: :status

  def initialize(trail, user:, status_finder:)
    super(trail)
    @trail = trail
    @user = user
    @status_finder = status_finder
  end

  def just_finished?
    complete? && status.created_at >= 5.days.ago
  end

  def update_status
    if completeables.all?(&:complete?)
      statuses.create!(user: user, state: Status::COMPLETE)
    elsif completeables.any?(&:in_progress?) || completeables.any?(&:complete?)
      statuses.create!(user: user, state: Status::IN_PROGRESS)
    end
  end

  def completeables
    CompleteableWithProgressQuery.new(
      status_finder: status_finder,
      completeables: trail.completeables,
    ).to_a
  end

  def status
    status_finder.current_status_for(trail)
  end

  def started_on
    earliest_status_date || Date.tomorrow
  end

  def steps_remaining
    completeables.
      count { |completeable| completeable.state != Status::COMPLETE }
  end

  private

  attr_reader :trail, :user, :status_finder

  def earliest_status_date
    earliest_status.try(:created_at).try(:to_date)
  end

  def earliest_status
    status_finder.earliest_status_for(trail)
  end
end
