require "rails_helper"

describe TwitterPlayerCardsController do
  it "removes the 'X-Frame-Options' header to allow cross-domain iframes" do
    stub_video

    get :show, params: {video_id: 123}

    expect(response.headers["X-Frame-Options"]).to be_nil
  end

  it "does not render a layout" do
    stub_video

    get :show, params: {video_id: 123}

    expect(response).to render_template(layout: false)
  end

  def stub_video
    allow(Video).to receive(:find).and_return(build_stubbed(:video))
  end
end
