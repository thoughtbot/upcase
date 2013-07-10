class SubscriberEngagementsController < ApplicationController
  def index
    @subscribers = Subscription.active.paid.map { |subscription| SubscriberEngagement.new(subscription.user) }
  end
end
