When 'I fill in the $field_name with "$value"' do |field_name,value|
  fill_in field_id_for(field_name), :with => value
end

When 'I blank the $field_name field' do |field_name|
  fill_in field_id_for(field_name), :with => ''
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

Then 'I see the "$error_message" error for the $field_name field' do |error_message, field_name|
  steps %{
    Then I see the "#{error_message}" error for the following fields:
      | #{field_name} |
  }
end

When 'I select the start date of "$date_string"' do |date_string|
  fill_in 'section_starts_on', :with => date_string
end

When 'I select the end date of "$date_string"' do |date_string|
  fill_in 'section_ends_on', :with => date_string
end

When 'I select the teacher "$teacher_name"' do |teacher_name|
  check teacher_name
end

When 'I deselect the teacher "$teacher_name"' do |teacher_name|
  uncheck teacher_name
end

Then 'the $field_name field should contain "$value"' do |field_name, expected_value|
  field = find_field(field_id_for(field_name))
  actual_value = (field.tag_name == 'textarea') ? field.text : field.value
  actual_value.should == expected_value
end

