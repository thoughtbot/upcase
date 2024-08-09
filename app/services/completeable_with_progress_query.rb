# Factory which can decorate an Exercise with the statuses for a given user
class CompleteableWithProgressQuery
  include Enumerable

  def initialize(status_finder:, completeables:)
    @status_finder = status_finder
    @completeables = completeables
  end

  def each(&)
    wrapped_completeables.each(&)
  end

  def includes(*args)
    self.class.new(
      status_finder: status_finder,
      completeables: completeables.includes(*args)
    )
  end

  protected

  attr_reader :completeables, :status_finder

  private

  def wrapped_completeables
    previous_completeable_state = Status::COMPLETE
    completeables.map do |completeable|
      state = state_for(completeable)
      CompleteableWithProgress
        .new(completeable, state, previous_completeable_state).tap do
        previous_completeable_state = state
      end
    end
  end

  def state_for(completeable)
    current_status_for(completeable).state
  end

  def current_status_for(completeable)
    @status_finder.current_status_for(completeable)
  end
end
