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
    {
      'staging' => '897f1eac6e4386017e50e718024cfc4a4e2e8cb2.1',
      'production' => 'fb630646a8d2b4cb9b5fae63ba61cc7cd2d194fb'
    }[Rails.env]
  end
end
