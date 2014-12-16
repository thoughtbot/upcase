require "rails_helper"

describe HomesController do
  it "renders the landing page if the visitor is not logged in" do
    get :show

    expect(response).
      to render_template("landing_pages/watch-one-do-one-teach-one")
  end

  it "redirects to products if the visitor is logged in" do
    sign_in

    get :show

    expect(response).to redirect_to practice_path
  end

  it "redirects to products if subscriber has access to exercises" do
    plan = build_stubbed(:plan, includes_exercises: true)
    subscriber = create(:user, :with_subscription, plan: plan)
    sign_in_as subscriber

    get :show

    expect(response).to redirect_to practice_path
  end

  it "redirects to The Weekly Iteration if subscriber has no exercise access" do
    create(:show, name: Show::THE_WEEKLY_ITERATION)
    plan = build_stubbed(:plan, includes_exercises: false)
    subscriber = create(:user, :with_subscription, plan: plan)
    sign_in_as subscriber

    get :show

    expect(response).to redirect_to Show.the_weekly_iteration
  end
end
