# Factory which can decorate an Exercise with the statuses for a given user
class CompleteableWithProgressQuery
  include Enumerable

  def initialize(user:, completeables:)
    @user = user
    @completeables = completeables
  end

  def each(&block)
    wrapped_completeables.each(&block)
  end

  def includes(*args)
    self.class.new(user: user, completeables: completeables.includes(*args))
  end

  protected

  attr_reader :completeables, :user

  private

  def wrapped_completeables
    previous_completeable_state = Status::COMPLETE
    completeables.map do |completeable|
      state = state_for(completeable)
      CompleteableWithProgress.
        new(completeable, state, previous_completeable_state).tap do
        previous_completeable_state = state
      end
    end
  end

  def state_for(completeable)
    status_for(completeable).state
  end

  def status_for(completeable)
    statuses["#{completeable.class.model_name}_#{completeable.id}"].
      try(:first) || Unstarted.new
  end

  def statuses
    @statuses ||= Status.
      where(completeable_id: completeable_ids, user: user).
      order("created_at DESC").
      group_by do |status|
        "#{status.completeable_type}_#{status.completeable_id}"
      end
  end

  def completeable_ids
    completeables.map(&:id)
  end

  def status_for_completeable?(status:, completeable:)
    status.completeable_id == completeable.id &&
      status.completeable_type == completeable.class.to_s
  end
end
