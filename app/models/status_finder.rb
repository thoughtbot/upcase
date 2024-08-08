class StatusFinder
  def initialize(user:)
    @user = user
  end

  def current_status_for(completeable)
    statuses_for(completeable).try(:first) || Unstarted.new
  end

  def earliest_status_for(completeable)
    statuses_for(completeable).try(:last) || Unstarted.new
  end

  private

  def statuses_for(completeable)
    statuses[key(completeable.class.name, completeable.id)]
  end

  def statuses
    @statuses ||= find_statuses
  end

  def find_statuses
    @user
      .statuses
      .order(created_at: :desc)
      .group_by do |status|
        key(status.completeable_type, status.completeable_id)
      end
  end

  def key(type, id)
    "#{type}_#{id}"
  end
end
