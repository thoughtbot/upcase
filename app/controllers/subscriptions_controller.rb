class SubscriptionsController < ApplicationController
  before_filter :must_be_subscription_owner, only: [:edit, :update]

  def new
    @landing_page = true
    @topics = define_topics
  end

  def edit
    @catalog = Catalog.new
  end

  def update
    current_user.subscription.change_plan(sku: params[:plan_id])
    redirect_to my_account_path,
                notice: I18n.t("subscriptions.flashes.change.success")
  end

  private

  LandingTopic = Struct.new(:name, :slug, :image, :target)

  def define_topics
    [
      ["Clean Code", "clean-code", "clean-code", topic_path("clean-code")],
      ["Git", "git", "workflow", video_path("git-workflow")],
      ["Ruby on Rails", "rails", "rails", topic_path("rails")],
      ["Testing", "testing", "testing", topic_path("testing")],
      ["iOS", "ios", "ios", topic_path("ios")],
      ["Haskell", "haskell", "haskell", topic_path("haskell")],
      ["JavaScript", "javascript", "javascript", topic_path("javascript")],
      ["Vim", "vim", "vim", topic_path("vim")],
      ["tmux", "tmux", "workflow", trail_path("tmux")],
      ["Design", "design", "design", topic_path("design")],
    ].map { |topic_details| LandingTopic.new(*topic_details) }
  end
end
