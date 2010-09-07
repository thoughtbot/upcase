When 'I fill in the $field_name with "$value"' do |field_name,value|
  fill_in field_id_for(field_name), :with => value
end

When 'I press the button to $button_action' do |button_action|
  click_button button_text_for(button_action)
end

When 'I check $check_box_description' do |check_box_description|
  check field_id_for(check_box_description)
end

Then 'I see the "$error_message" error for the following fields:' do |error_message, table|
  table.raw.each do |field,|
    within("##{field_id_for(field)}_input") do
      page.should have_content(error_message), "expected #{field} to have the error: #{error_message}"
    end
  end
end
