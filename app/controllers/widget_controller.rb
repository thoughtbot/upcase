class WidgetController < ApplicationController
  before_filter :validate_api_key

  respond_to :json

  def show
    raise 'Subclass this controller and implement this action'
  end

  private

  def current_plan
    PlanFinder.where(sku: params[:sku]).first
  end

  def number_widget(number)
    {
      item: [
        { text: '', value: number }
      ]
    }
  end

  def money_widget(first)
    {
      item: [
        { text: '', value: first, prefix: '$' }
      ]
    }
  end

  def validate_api_key
    if params[:key] != ENV['WIDGETS_API_KEY']
      render nothing: true, status: :not_found
    end
  end
end
