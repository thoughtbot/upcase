module TrailHelpers
  def build_completeable_with_progress(state: Status::UNSTARTED)
    CompleteableWithProgress.new(build_stubbed(:video), state)
  end
end
