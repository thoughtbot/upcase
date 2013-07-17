class SubscriberEngagementsController < ApplicationController
  before_filter :must_be_admin

  def index
    @subscribers = Subscription.active.paid.map { |subscription| SubscriberEngagement.new(subscription.user) }
  end
end
