require "rails_helper"

describe "conversions/_purchased.html.erb" do
  before do
    view_stubs(
      current_user: stub("user", id: user_id),
      purchased_hash: ""
    )
  end

  def user_id
    123
  end

  it "aliases the user id" do
    render

    expect(rendered).to include(%{analytics.alias("#{user_id}")})
  end
end
