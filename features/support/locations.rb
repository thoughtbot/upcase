module Locations
  def location_for(location_name)
    case location_name
    when 'Boston'
      { address: '41 Winter St ste 7',
        city: 'Boston',
        state: 'MA',
        zip: '02108' }
    end
  end
end

World(Locations)
