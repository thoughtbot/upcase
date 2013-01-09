module DateHelpers
  def workshop_date_string(start_date_string, end_date_string)
    start_date = Date.parse(start_date_string)
    end_date = Date.parse(end_date_string)
    "#{Date::MONTHNAMES[start_date.month]} #{start_date.day}-#{end_date.day}, #{start_date.year}"
  end
end

World(DateHelpers)
