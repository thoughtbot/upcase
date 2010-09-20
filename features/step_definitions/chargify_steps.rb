Given 'the following Chargify customer exists:' do |table|
  # sets up the chargify mocks
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

When 'Chargify responds with the following user information:' do |table|
  # does a GET to a URL
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

Given 'the following course exists on Chargify:' do |table|
  Courses.add!(table.hashes.first)

  chargify_id_row = false
  new_raw_table = table.raw.map do |row|
    new_row = row.dup
    chargify_id_row ||= new_row.index('chargify id')
    new_row.delete_at(chargify_id_row)
    new_row
  end
  new_table = Cucumber::Ast::Table.new(new_raw_table)

  Given %{the following course exists:}, new_table
end

Given 'the following section exists on Chargify:' do |table|
  Sections.add!(table.hashes.first)
  Given %{the following section exists:}, table
end

Given 'the following section taught by "$teacher_name" exists on Chargify:' do |teacher_name, table|
  Sections.add!(table.hashes.first)
  Given %{the following section taught by "#{teacher_name}" exists:}, table
end

When 'I fill in the following Chargify customer:' do |table|
  table.hashes.each do |customer_hash|
    customer_hash.each do |field,value|
      fill_in field.gsub(' ','-'), :with => value
    end
  end
end
