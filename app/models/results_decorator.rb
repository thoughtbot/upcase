class ResultsDecorator
  def initialize(complete, filtered)
    @complete = complete
    @filtered = filtered
  end

  def all
    @complete
  end

  def hidden
    @complete - @filtered
  end

  def visible
    @filtered
  end
end
