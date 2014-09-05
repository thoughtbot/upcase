require "rails_helper"

describe 'promoted_catalogs/show.html.erb' do
  context "when signed in without a subscription" do
    before do
      view_stubs(signed_in?: true)
      view_stubs(current_user_has_active_subscription?: false)
      view_stubs(current_user_is_subscription_owner?: false)
      assign_catalog
      render
    end

    it "includes a settings link" do
      expect(rendered).to include(link_to("Settings", my_account_path))
    end

    it "does not include a sign in link" do
      expect(rendered).not_to include(link_to("Sign in", sign_in_path))
    end

    it "includes a membership link" do
      expect(rendered).to include("Upcase Membership")
    end
  end

  context "when signed in with a subscription" do
    before do
      view_stubs(signed_in?: true)
      view_stubs(current_user_has_active_subscription?: true)
      view_stubs(current_user_is_subscription_owner?: true)
      assign_catalog
      render
    end

    it "does not include a membership link" do
      expect(rendered).not_to include("Upcase Membership")
    end
  end

  context 'when signed out' do
    include Gravatarify::Helper
    include MentorHelper

    before { view_stubs(signed_in?: false) }
    before { view_stubs(current_user_has_active_subscription?: true) }

    it 'includes a sign in link' do
      assign_catalog

      render

      expect(rendered).to include(link_to('Sign in', sign_in_path))
    end

    it 'does not include a sign out link' do
      assign_catalog

      render

      expect(rendered).
        not_to include(link_to('Sign out', sign_out_path, method: :delete))
    end

    it 'does not include an account link' do
      assign_catalog

      render

      expect(rendered).not_to include(link_to('Account', my_account_path))
    end

    it 'includes promoted books' do
      book = build_stubbed(:book, product_image_file_name: 'some file')
      assign_catalog(books: [book])
      view_stubs(signed_in?: false)

      render

      expect(rendered).to have_css("a[href='#{book_path(book)}']")
    end

    it 'includes promoted screencasts' do
      screencast = build_stubbed(
        :screencast,
        short_description: 'some description',
        product_image_file_name: 'some file',
      )
      assign_catalog(screencasts: [screencast])
      view_stubs(signed_in?: false)

      render

      expect(rendered).to include(screencast.name)
      expect(rendered).to include(screencast.short_description)
      expect(rendered).to include(image_tag(screencast.image_url))
    end

    it 'includes promoted video_tutorials' do
      video_tutorial = build_stubbed(:video_tutorial)

      assign_catalog(video_tutorials: [video_tutorial])
      view_stubs(signed_in?: false)

      render

      expect(rendered).to include(video_tutorial.name)
      expect(rendered).to include(video_tutorial.short_description)
      expect(rendered).to include(image_tag(video_tutorial.thumbnail_path))
      link_title = "The #{video_tutorial.name} online video tutorial details"
      expect(rendered).
        to have_css("a[href='#{video_tutorial_path(video_tutorial)}'][title='#{link_title}']")
    end

    it 'includes featured mentors' do
      mentor = build_stubbed(:mentor)
      mentor.stubs(bio: 'that guy')

      assign_catalog(mentors: [mentor])
      view_stubs(signed_in?: false)

      render

      expect(rendered).to include(mentor.first_name)
      expect(rendered).to include(mentor.bio)
      expect(rendered).to include(mentor_image(mentor))
    end
  end

  def assign_catalog(books: [], video_tutorials: [], screencasts: [], mentors: [])
    assign(
      :catalog,
      stub(
        books: books,
        video_tutorials: video_tutorials,
        screencasts: screencasts,
        mentors: mentors
      )
    )
  end
end
