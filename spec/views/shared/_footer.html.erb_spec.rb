require "rails_helper"

describe "shared/_footer.html.erb" do
  context "when not signed in" do
    it "does not show the repositories link" do
      render_footer signed_in: false

      expect(rendered).not_to have_content("Upcase source code")
    end

    it "does show the contact us link" do
      render_footer signed_in: false

      expect(rendered).to have_content("Contact us")
    end

    it "does show a sign in link" do
      render_footer signed_in: false

      expect(rendered).to have_content("Sign in")
      expect(rendered).not_to have_content("Sign out")
    end
  end

  context "when user is signed in" do
    it "does show the repositories link" do
      render_footer signed_in: true, current_user: build_stubbed(:user)

      expect(rendered).to have_content("Upcase source code")
    end

    it "does not show the contact us link" do
      render_footer signed_in: true, current_user: build_stubbed(:user)

      expect(rendered).not_to have_content("Contact us")
    end

    it "does show a sign out link" do
      render_footer signed_in: true, current_user: build_stubbed(:user)

      expect(rendered).to have_content("Sign out")
      expect(rendered).not_to have_content("Sign in")
    end

    context "when the user is not an admin" do
      it "does not render a link to the admin" do
        render_footer signed_in: true, current_user: build_stubbed(:user)

        expect(rendered).not_to have_admin_link
      end
    end

    context "when the user is an admin" do
      it "renders a link to the admin" do
        render_footer signed_in: true, current_user: build_stubbed(:admin)

        expect(rendered).to have_admin_link
      end
    end

    context "when the user does not have an active subscription" do
      it "includes an 'Upgrade' link" do
        render_footer(
          signed_in: true,
          current_user: build_stubbed(:user),
          has_subscription: false,
        )

        expect(rendered).to have_upgrade_link
      end
    end

    context "when the user has an active subscription" do
      it "does not include an 'Upgrade' link" do
        render_footer(
          signed_in: true,
          current_user: build_stubbed(:user),
          has_subscription: true,
        )

        expect(rendered).not_to have_upgrade_link
      end
    end
  end

  def render_footer(signed_in:, current_user: nil, has_subscription: false)
    view_stub_with_return(signed_in?: signed_in)
    view_stub_with_return(current_user: current_user)
    view_stub_with_return(
      current_user_has_active_subscription?: has_subscription,
    )
    render
  end

  def have_admin_link
    have_link("Admin", href: admin_path)
  end

  def have_upgrade_link
    have_link("Upgrade", href: join_path)
  end
end
