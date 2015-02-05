require "rails_helper"

describe 'videos/_download_link.html.erb' do
  it "includes the clip's download url" do
    clip = double("clip")
    allow(clip).to receive(:download_url).
      and_return("http://example.com/download")

    render_partial(clip)

    expect(rendered).to include(%{href="#{clip.download_url}"})
  end

  def render_partial(clip)
    render 'videos/download_link',
      clip: clip,
      download_type_key: '',
      download_type: '',
      size_display: ''
  end
end
