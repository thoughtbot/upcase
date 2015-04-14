class StatusUpdater
  def initialize(completeable, user)
    @completeable = completeable
    @user = user
  end

  def update_state(state)
    create_status(state)
    update_trail
  end

  protected

  attr_reader :completeable, :user

  private

  def create_status(state)
    Status.create!(completeable: completeable, user: user, state: state)
  end

  def update_trail
    trail = completeable.trail
    if trail.present?
      trail.update_state_for(user)
    end
  end
end
