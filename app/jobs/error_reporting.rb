module ErrorReporting
  def error(job, exception)
    Airbrake.notify(exception)
  end
end
