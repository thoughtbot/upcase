module WorkshopsHelper
  def workshops_json(workshops, callback = nil)
    json = workshops.map! do |workshop|
      workshop_json = { 'workshop' => workshop.as_json }
      workshop_json['workshop'].merge!(url: workshop_url(workshop))
      workshop_json
    end.to_json
    json = "#{callback}(#{json})" if callback
    json.html_safe
  end

  def workshop_card_classes(workshop)
    classes = ["workshop", 'product-card']
    classes << workshop_card_status(workshop)
    classes.join(' ')
  end

  def workshop_card_status(workshop)
    if workshop.purchase_for(current_user) && signed_in?
      workshop.purchase_for(current_user).status
    end
  end
end
