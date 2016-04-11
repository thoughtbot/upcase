require "rails_helper"

describe CheckoutsHelper do
  describe "#auth_method_class" do
    context "when the user has entered username/password data" do
      it "returns 'username-password-auth'" do
        checkout = build_checkout(signing_up_with_username_and_password?: true)

        result = helper.auth_method_class(checkout)

        expect(result).to eq("username-password-auth")
      end
    end

    context "when the user has not entered username/password data" do
      it "returns 'github-auth'" do
        checkout = build_checkout(signing_up_with_username_and_password?: false)

        result = helper.auth_method_class(checkout)

        expect(result).to eq("github-auth")
      end
    end
  end

  def build_checkout(options)
    instance_double(Checkout, options)
  end
end
