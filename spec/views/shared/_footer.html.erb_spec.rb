require "rails_helper"

describe "shared/_footer.html.erb" do
  context "when not signed in" do
    it "does not show the repositories link" do
      stub_signed_in(false)

      render

      expect(rendered).not_to have_content("Upcase source code")
    end

    it "does show the contact us link" do
      stub_signed_in(false)

      render

      expect(rendered).to have_content("Contact us")
    end

    it "does show a sign in link" do
      stub_signed_in(false)

      render

      expect(rendered).to have_content("Sign in")
      expect(rendered).not_to have_content("Sign out")
    end
  end

  context "when user is signed in" do
    it "does show the repositories link" do
      stub_signed_in(true)
      stub_current_user_with create(:user)

      render

      expect(rendered).to have_content("Upcase source code")
    end

    it "does not show the contact us link" do
      stub_signed_in(true)
      stub_current_user_with create(:user)

      render

      expect(rendered).not_to have_content("Contact us")
    end

    it "does show a sign out link" do
      stub_signed_in(true)
      stub_current_user_with create(:user)

      render

      expect(rendered).to have_content("Sign out")
      expect(rendered).not_to have_content("Sign in")
    end

    context "when the user is not an admin" do
      it "does not render a link to the admin" do
        stub_signed_in(true)
        stub_current_user_with build_stubbed(:user)

        render

        expect(rendered).not_to have_admin_link
      end
    end

    context "when the user is an admin" do
      it "renders a link to the admin" do
        stub_signed_in(true)
        stub_current_user_with build_stubbed(:admin)

        render

        expect(rendered).to have_admin_link
      end
    end

    context "when the user does not have an active subscription" do
      it "includes an 'Upgrade' link" do
        stub_signed_in(true)
        stub_current_user_with build_stubbed(:user)

        render

        expect(rendered).to have_upgrade_link
      end
    end

    context "when the user has an active subscription" do
      it "does not include an 'Upgrade' link" do
        stub_signed_in(true)
        subscriber = build_user_with_active_subscription
        stub_current_user_with subscriber

        render

        expect(rendered).not_to have_upgrade_link
      end
    end
  end

  def have_admin_link
    have_link("Admin", href: admin_path)
  end

  def have_upgrade_link
    have_link("Upgrade", href: join_path)
  end

  def build_user_with_active_subscription
    build_stubbed(:subscriber).tap do |subscriber|
      allow(subscriber).to receive(:has_active_subscription?).and_return(true)
    end
  end

  def stub_signed_in(result)
    view_stub_with_return(signed_in?: result)
  end

  def stub_current_user_with(user)
    view_stub_with_return(current_user: user)
  end
end
