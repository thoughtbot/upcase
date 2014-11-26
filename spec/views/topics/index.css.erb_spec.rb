require "rails_helper"

describe "topics/index.css.erb" do
  it "generates CSS with topic colors" do
    topic = build_stubbed(
      :topic,
      slug: "analytics",
      color: "blue",
      color_accent: "red"
    )
    assign :topics, [topic]

    render

    expect(rendered).to match(/.analytics .subject {/)
    expect(rendered).to match(/background: blue/)
    expect(rendered).to match(/color: red/)
  end
end
