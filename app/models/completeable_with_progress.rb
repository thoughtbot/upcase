class CompleteableWithProgress < SimpleDelegator
  def initialize(completeable, state, previous_completeable_state = nil)
    super(completeable)
    @completeable = completeable
    @state = state
    @previous_completeable_state = previous_completeable_state
  end

  def state
    if next_up?
      Status::NEXT_UP
    else
      @state
    end
  end

  def unstarted?
    [Status::UNSTARTED, Status::NEXT_UP].include? state
  end

  def in_progress?
    state == Status::IN_PROGRESS
  end

  def complete?
    state == Status::COMPLETE
  end

  private

  def next_up?
    @previous_completeable_state == Status::COMPLETE &&
      @state == Status::UNSTARTED
  end
end
