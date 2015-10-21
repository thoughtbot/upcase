require "rails_helper"

describe "payments/new.html.erb" do
  context "when the user has a name from GitHub" do
    it "addresses them with that name" do
      stub_professional_plan
      stub_current_user
      name = "Ralph Robot"
      @github_user = github_user(name: name)

      render

      expect(rendered).to have_content "Hey #{name}"
    end
  end

  context "when the user does not have a name from GitHub" do
    it "addresses them with 'Hey there'" do
      stub_professional_plan
      stub_current_user
      @github_user = github_user(name: nil)

      render

      expect(rendered).to have_content "Hey there"
    end
  end

  def stub_current_user
    user = User.new
    allow(view).to receive(:current_user).and_return(user)
  end

  def stub_professional_plan
    allow(Plan).to(
      receive(:professional).and_return(double(price_in_dollars: 1)),
    )
  end

  def github_user(name:)
    double(name: name, avatar_url: "/whatever")
  end
end
