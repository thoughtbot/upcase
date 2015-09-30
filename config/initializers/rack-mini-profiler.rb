if Rails.env.development?
  require "rack-mini-profiler"

  Rack::MiniProfilerRails.initialize!(Rails.application)

  Rails.application.middleware.delete(Rack::MiniProfiler)
  Rails.application.middleware.insert_after(Rack::Deflater, Rack::MiniProfiler)
end
