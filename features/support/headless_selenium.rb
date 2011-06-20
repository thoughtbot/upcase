Before('@selenium') do
  if ENV["SELENIUM_HEADLESS"] == 'true'
    require "headless"
    @headless = Headless.new
    @headless.start
  end
end

After('@selenium') do
  begin
    @headless.destroy if @headless.present?
  rescue Errno::EPERM => e
    p e.message
  end
end

