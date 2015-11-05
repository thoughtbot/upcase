class StatusFinder
  def initialize(user:)
    @user = user
  end

  def status_for(completeable)
    statuses[key(completeable.class.name, completeable.id)].try(:first) ||
      Unstarted.new
  end

  private

  def statuses
    @statuses ||= find_statuses
  end

  def find_statuses
    if @user.nil?
      {}
    else
      @user.
        statuses.
        order(created_at: :desc).
        group_by do |status|
          key(status.completeable_type, status.completeable_id)
        end
    end
  end

  def key(type, id)
    "#{type}_#{id}"
  end
end
