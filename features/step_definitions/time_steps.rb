require 'timecop'

Given 'today is $date' do |date_string|
  Timecop.freeze(DateTime.parse(date_string))
end

Given 'time is unfrozen' do
  time = Time.zone.now
  Timecop.return
  Timecop.travel(time)
end

After do
  Timecop.return
end
