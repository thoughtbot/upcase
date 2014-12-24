require "rails_helper"

describe "shared/_footer.html.erb" do
  context "when not signed in" do
    it "does not show the repositories link" do
      view_stubs(signed_in?: false)

      render

      expect(rendered).not_to have_content("Upcase source code")
    end

    it "does show the contact us link" do
      view_stubs(signed_in?: false)

      render

      expect(rendered).to have_content("Contact us")
    end

    it "does show a sign in link" do
      view_stubs(signed_in?: false)

      render

      expect(rendered).to have_content("Sign in")
      expect(rendered).not_to have_content("Sign out")
    end
  end

  context "when user is signed in" do
    it "does show the repositories link" do
      view_stubs(signed_in?: true)
      view_stubs(current_user: create(:user))

      render

      expect(rendered).to have_content("Upcase source code")
    end

    it "does not show the contact us link" do
      view_stubs(signed_in?: true)
      view_stubs(current_user: create(:user))

      render

      expect(rendered).not_to have_content("Contact us")
    end

    it "does show a sign out link" do
      view_stubs(signed_in?: true)
      view_stubs(current_user: create(:user))

      render

      expect(rendered).to have_content("Sign out")
      expect(rendered).not_to have_content("Sign in")
    end
  end
end
