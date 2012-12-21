Then /^I should receive the following CSV file:$/ do |expected_csv|
  page.response_headers['Content-Type'].should =~ %r{text/csv}

  expected_rows = expected_csv.hashes

  actual_csv = CSV.new(page.source, headers: true)
  actual_rows = actual_csv.map(&:to_hash)

  expected_rows.zip(actual_rows).each do |expected, actual|
    actual.should eq expected
  end
end
