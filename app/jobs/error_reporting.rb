module ErrorReporting
  def error(job, exception)
    Sentry.capture_exception(exception)
  end
end
