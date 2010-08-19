Then 'I see the empty section description' do
  response.should contain('No courses are running at this time')
end

Then 'I see the external registration link to "$url"' do |url|
  response.should have_tag('a[href=?]', url)
end
