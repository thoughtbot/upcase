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

  def workshop_frequency_note(workshop)
    if workshop.starts_immediately?
      "This #{workshop.fulfillment_method} workshop
       starts as soon as you register."
    else
      "This #{workshop.fulfillment_method} workshop is held about every
      six weeks. #{link_to 'Get notified', '#new_follow_up'} when the next one
      is scheduled.".html_safe
    end
  end

  def workshop_card_classes(workshop)
    classes = ["workshop-#{workshop.fulfillment_method}", 'product-card']
    if workshop.purchase_for(current_user) && signed_in?
      classes << workshop.purchase_for(current_user).status
    end
    classes.join(' ')
  end

  def workshop_card_status(workshop)
    if workshop.purchase_for(current_user) && signed_in?
      workshop.purchase_for(current_user).status
    end
  end
end
