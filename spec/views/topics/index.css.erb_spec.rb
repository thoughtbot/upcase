require "rails_helper"

describe "topics/index.css.erb" do
  it "generates CSS with topic colors" do
    topic = build_stubbed(
      :topic,
      slug: "analytics",
      color: "blue",
      color_accent: "red",
      image_file_name: "example.jpg"
    )
    allow(Topic).to receive(:with_colors).and_return([topic])

    render

    expect(rendered).to match(/background: blue/)
    expect(rendered).to match(/color: red/)
    expect(rendered).to match(/background: url\(".*example\.jpg"\)/)
  end
end
