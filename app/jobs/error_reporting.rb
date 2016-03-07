module ErrorReporting
  def error(job, exception)
    Honeybadger.notify(exception)
  end
end
