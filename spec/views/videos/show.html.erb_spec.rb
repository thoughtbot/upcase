require "rails_helper"

describe "videos/show" do
  include VideoHelpers

  it "sets the page title to the video title" do
    video = build_stubbed(:video, name: "hello world")

    render_video video
    expect(page_title).to include(video.name)
  end

  describe "twitter card" do
    context "when there is a preview video available" do
      it "renders the twitter card meta data" do
        video = build_stubbed(:video, :with_preview)

        render_video video

        expect(head_content).to have_twitter_card
      end
    end

    context "when there is not a preview video available" do
      it "does not render a twitter card" do
        video = build_stubbed(:video, preview_wistia_id: nil)

        render_video video

        expect(head_content).not_to have_twitter_card
      end
    end
  end

  it "include the video name and link to the parent watchable" do
    show = create(:show)
    video = create(:video, watchable: show)

    render_video video

    expect(subject_block).to have_css("h1", text: video.name)
    expect(subject_block).to have_link(show.name, href: show_path(show))
  end

  describe "preview notice and CTA" do
    context "the user is signed out" do
      it "displays the auth to access CTA for the video" do
        video = build_stubbed(:video)

        render_video video, signed_in: false

        expect(rendered).to have_access_callout
      end
    end

    context "the user is signed in" do
      it "does not display the notice or sign in CTA" do
        video = build_stubbed(:video, watchable: build_stubbed(:show))

        render_video video, signed_in: true

        expect(rendered).not_to have_access_callout
      end
    end
  end

  describe "video player" do
    context "when the user is signed in" do
      it "displays the full video" do
        video = build_stubbed(:video)

        render_video video, signed_in: true

        expect(rendered).to be_displaying_full_video(video)
      end
    end

    context "when the user is signed out" do
      context "when the video is part of a trail and does not have a preview" do
        it "displays the title card image" do
          video = create_video_on_a_trail

          render_video video, signed_in: false

          expect(rendered).to have_video_title_card_image
        end
      end
    end
  end

  describe "mark as complete button" do
    context "when the user is signed in" do
      it "displays the button" do
        video = build_stubbed(:video)

        render_video video, signed_in: true

        expect(rendered).to have_mark_as_complete_button
      end
    end

    context "when the user is signed out" do
      it "does not display the button" do
        video = build_stubbed(:video)

        render_video video, signed_in: false

        expect(rendered).not_to have_mark_as_complete_button
      end
    end
  end

  describe "video notes" do
    context "when the video has notes" do
      it "renders the notes" do
        video = build_stubbed(:video, notes: "## notes\n\n here")

        render_video video

        expect(rendered).to have_notes_section
        expect(rendered).to have_css("h2", text: "notes")
      end
    end

    context "when the video does not have notes" do
      it "does not render a notes section" do
        video = build_stubbed(:video, notes: nil)

        render_video video

        expect(rendered).not_to have_notes_section
      end
    end
  end

  describe "comments" do
    context "when the video is published" do
      it "renders the comments for the video" do
        video = build_video(published: true)

        render_video video

        expect(rendered).to have_css("#discourse-comments")
      end
    end

    context "when the video is not published" do
      it "does not render the comments for the video" do
        video = build_video(published: false)

        render_video video

        expect(rendered).not_to have_css("#discourse-comments")
      end
    end
  end

  describe "seek markers" do
    context "when the user is signed in" do
      it "renders the markers" do
        video = build_stubbed(:video)

        render_video video, signed_in: true

        expect(rendered).to have_seek_buttons
      end
    end

    context "when the user is signed out" do
      it "does not render the markers" do
        video = build_stubbed(:video)

        render_video video, signed_in: false

        expect(rendered).not_to have_seek_buttons
      end
    end
  end

  def have_twitter_card
    have_css("meta[name='twitter:player']")
  end

  def be_displaying_full_video(video)
    be_displaying_video_with_id(video.wistia_id)
  end

  def have_mark_as_complete_button
    have_css(".mark-as-complete")
  end

  def have_notes_section
    have_css("h3", text: "Notes")
  end

  def have_seek_buttons
    have_css(".seek-button-template")
  end

  def have_access_callout
    have_css(".access-callout")
  end

  def be_displaying_video_with_id(video_id)
    have_css("p[data-wistia-id='#{video_id}']")
  end

  def have_video_title_card_image
    have_css(".title-card")
  end

  def head_content
    wrapped_block(view.content_for(:head))
  end

  def subject_block
    wrapped_block(view.content_for(:subject_block))
  end

  def page_title
    view.content_for(:page_title)
  end

  def wrapped_block(content)
    Capybara.string("<div>#{content}</div>")
  end

  def build_video(published:)
    build_stubbed(:video, :published).tap do |video|
      allow(video).to receive(:published?).and_return(published)
    end
  end

  def render_video(video, signed_in: true)
    assign(:video, video)
    user = build_stubbed(:user)
    allow(view).to receive(:current_user).and_return(user)
    allow(view).to receive(:current_user_has_access_to?).and_return(false)
    allow(view).to receive(:signed_in?).and_return(signed_in)
    allow(view).to receive(:signed_out?).and_return(!signed_in)
    allow(view).to receive(:github_auth_path).and_return("/fake/auth/path")
    render template: "videos/show"
  end
end
