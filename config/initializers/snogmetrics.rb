module Snogmetrics
  def output_strategy
    case Rails.env.to_s
    when 'development'
      :console_log
    when 'test'
      :array
    else
      :live
    end
  end

  def kissmetrics_api_key
    ENV['KISSMETRICS_API_KEY']
  end
end
