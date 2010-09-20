Given '"$teacher_name" is teaching the section from "$section_start" to "$section_end"' do |teacher_name, section_start, section_end|
  start_date = Date.parse(section_start)
  end_date = Date.parse(section_end)
  section = Section.find_by_starts_on_and_ends_on!(start_date, end_date)
  teacher = Teacher.find_by_name!(teacher_name)
  Factory(:section_teacher, :section => section, :teacher => teacher)
end

