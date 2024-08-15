require "rails_helper"

describe "layouts/_footer.html.erb" do
  context "when not signed in" do
    it "does not show the repositories link" do
      view_stub_with_return(signed_in?: false)

      render template: "layouts/_footer"

      expect(rendered).not_to have_content("Upcase source code")
    end

    it "does show the contact us link" do
      view_stub_with_return(signed_in?: false)

      render template: "layouts/_footer"

      expect(rendered).to have_content("Contact us")
    end

    context "when not on the signin page" do
      it "does not show a sign out link" do
        view_stub_with_return(signed_in?: false)

        render template: "layouts/_footer"

        expect(rendered).not_to have_content("Sign out")
      end
    end
  end

  context "when user is signed in" do
    it "does show the repositories link" do
      view_stub_with_return(signed_in?: true)
      view_stub_with_return(current_user: create(:user))

      render template: "layouts/_footer"

      expect(rendered).to have_content("Upcase source code")
    end

    it "does show a sign out link" do
      view_stub_with_return(signed_in?: true)
      view_stub_with_return(current_user: create(:user))

      render template: "layouts/_footer"

      expect(rendered).to have_content("Sign out")
    end
  end
end
