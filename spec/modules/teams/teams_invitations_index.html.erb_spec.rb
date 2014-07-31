require "spec_helper"

describe "teams/invitations/index", type: :view do
  it "renders no invitations" do
    assign(:team, build(:team))

    render

    expect(rendered).to have_content "You haven't invited anyone"
  end

  it "renders pending invitations" do
    email = "pat@thoughtbot.com"
    invitation = build(:invitation, email: email)
    assign(:team, build(:team, invitations: [invitation]))

    render

    expect(rendered).to have_content email
    expect(rendered).to have_content "Pending"
  end

  it "renders accepted invitations" do
    email = "pat@thoughtbot.com"
    invitation = build(:invitation, :accepted, email: email)
    assign(:team, build(:team, invitations: [invitation]))

    render

    expect(rendered).to have_content email
    expect(rendered).to have_content "Accepted"
    expect(rendered).to have_content invitation.recipient_name
  end
end
