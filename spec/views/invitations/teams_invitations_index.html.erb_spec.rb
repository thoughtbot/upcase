require "rails_helper"

describe "invitations/index" do
  it "renders no invitations" do
    assign(:team, build_stubbed(:team))

    render

    expect(rendered).to have_content "You haven't invited anyone"
  end

  it "renders pending invitations" do
    email = "pat@thoughtbot.com"
    invitation = build_stubbed(:invitation, email: email)
    assign(:team, build_stubbed(:team, invitations: [invitation]))

    render

    expect(rendered).to have_content email
    expect(rendered).to have_content "Pending"
  end

  it "renders accepted invitations" do
    email = "pat@thoughtbot.com"
    invitation = build_stubbed(:invitation, :accepted, email: email)
    assign(:team, build_stubbed(:team, invitations: [invitation]))

    render

    expect(rendered).to have_content email
    expect(rendered).to have_content "Accepted"
    expect(rendered).to have_content invitation.recipient_name
  end
end
