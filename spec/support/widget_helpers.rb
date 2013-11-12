module WidgetHelpers
  def number_widget_first_value
    json_response['item'].first['value']
  end

  def json_response
    JSON.parse(response.body)
  end
end
