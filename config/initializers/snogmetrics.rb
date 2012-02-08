STAGING_KISSMETRICS_API_KEY = '897f1eac6e4386017e50e718024cfc4a4e2e8cb2.1'

KISSMETRICS_API_KEY = {
  'test'        => 'abc123',
  'development' => STAGING_KISSMETRICS_API_KEY,
  'staging'     => STAGING_KISSMETRICS_API_KEY,
  'production'  => 'fb630646a8d2b4cb9b5fae63ba61cc7cd2d194fb'
}[Rails.env]

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
    ::KISSMETRICS_API_KEY
  end
end
