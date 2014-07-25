require "spec_helper"

describe "licenses/index.html.erb" do
  it "renders table rows for every license" do
    licenses = build_stubbed_list(:license, 2)
    assign :licenses, licenses

    render template: "licenses/index"

    license_table_rows = render(
      partial: "licenses/table_row",
      collection: licenses,
      as: :license
    )

    expect(rendered).to include(license_table_rows)
  end
end
