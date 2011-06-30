module RecordHelpers
  def section(start_date_string, end_date_string)
    start_date = Date.parse(start_date_string)
    end_date = Date.parse(end_date_string)
    Section.find_by_starts_on_and_ends_on!(start_date, end_date)
  end
end

World(RecordHelpers)
