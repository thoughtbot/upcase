class Unstarted
  def state
    Status::UNSTARTED
  end

  def unstarted?
    true
  end

  def in_progress?
    false
  end

  def complete?
    false
  end
end
