module WorkshopsHelper
  def workshops_json(workshops, callback = nil)
    json = workshops.map! do |workshop|
      workshop_json = workshop.as_json
      workshop_json['workshop'].merge!(url: workshop_url(workshop))
      workshop_json
    end.to_json
    json = "#{callback}(#{json})" if callback
    json.html_safe
  end

  def workshop_data_role(workshop)
    if workshop.online?
      'online-workshop'
    else
      'in-person-workshop'
    end
  end

  def workshop_delivery_method(workshop)
    if workshop.online?
      'online'
    else
      'in-person'
    end
  end
end
