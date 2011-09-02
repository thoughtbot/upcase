Then /^KISSmetrics receives the "([^"]*)" event with:$/ do |event_name, table|
  properties = table.rows_hash

  if using_javascript_driver?
    kmq = JSON.parse(page.evaluate_script("JSON.stringify(_kmq)"))
    matched_event = kmq.detect { |call| call == ["record", event_name, properties] }
    matched_event.should be
  else
    expected_javascript = %Q{_kmq.push(["record","#{event_name}",#{properties.to_json}]);}
    page.should have_content(expected_javascript)
  end
end

Then /^KISSmetrics does not receive the "([^"]*)" event$/ do |event_name|
  if using_javascript_driver?
    kmq = JSON.parse(page.evaluate_script("JSON.stringify(_kmq)"))
    matched_event = kmq.detect { |call| call == ["record", event_name, properties] }
    matched_event.should be_nil
  else
    unexpected_javascript = %Q{_kmq.push(["record","#{event_name}"}
    page.should have_no_content(unexpected_javascript)
  end
end

Then /^KISSmetrics receives the following properties:$/ do |table|
  table.hashes.each do |hash|
    property            = hash['property']
    value               = hash['value']
    expected_javascript = %Q{_kmq.push(['set', { '#{property}': '#{value}' }]);}

    page.should have_content(expected_javascript)
  end
end
