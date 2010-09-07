When 'I fill in the $field_name with "$value"' do |field_name,value|
  fill_in field_id_for(field_name), :with => value
end

When 'I press the button to $button_action' do |button_action|
  click_button button_text_for(button_action)
end

When 'I check $check_box_description' do |check_box_description|
  check field_id_for(check_box_description)
end
