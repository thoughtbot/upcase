require "rails_helper"

describe 'products/_forum_link' do
  context "with a user" do
    it 'includes a link to the forum' do
      render partial: "products/forum_link", locals: { current_user: site_user }
      expect(rendered).to include("View Forum")
    end
  end

  def site_user
    double("user")
  end
end
