class VideoWithStatus < SimpleDelegator
  attr_reader :status

  def initialize(video, status)
    super(video)
    @status = status
  end

  def status_class
    status.state.parameterize
  end

  def to_model
    self
  end
end
