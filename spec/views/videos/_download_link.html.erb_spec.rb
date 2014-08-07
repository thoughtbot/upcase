require "rails_helper"

describe 'videos/_download_link.html.erb', type: :view do
  it "includes the clip's download url" do
    clip = stub('clip')
    clip.stubs(:download_url).returns('http://example.com/download')

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
