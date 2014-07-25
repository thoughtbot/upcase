require "spec_helper"

describe "licenses/_table_row.html.erb" do
  it "renders license information" do
    license = create(:license)

    render "licenses/table_row", license: license

    rendered.should include(link_to(license.licenseable_name, license.licenseable))
    rendered.should include(license.created_at.to_s(:short_date))
  end
end
