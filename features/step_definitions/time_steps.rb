Given 'today is $date' do |date_string|
  Timecop.freeze(Date.parse(date_string))
end
