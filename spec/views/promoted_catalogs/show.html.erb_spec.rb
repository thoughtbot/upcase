require 'spec_helper'

describe 'promoted_catalogs/show.html.erb' do
  context 'when signed in' do
    before { view_stubs(signed_in?: true) }

    it 'includes a sign out link' do
      assign_catalog

      render

      expect(rendered).
        to include(link_to('Sign out', sign_out_path, method: :delete))
    end

    it 'includes an account link' do
      assign_catalog

      render

      expect(rendered).to include(link_to('Account', my_account_path))
    end

    it 'does not include a sign in link' do
      assign_catalog

      render

      expect(rendered).not_to include(link_to('Sign in', sign_in_path))
    end
  end

  context 'when signed out' do
    include Gravatarify::Helper
    include MentorHelper

    before { view_stubs(signed_in?: false) }

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

      expect(rendered).to include(book_image_link(book))
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

    it 'includes promoted workshops' do
      workshop = build_stubbed(:workshop)

      assign_catalog(workshops: [workshop])
      view_stubs(signed_in?: false)

      render

      expect(rendered).to include(workshop.name)
      expect(rendered).to include(workshop.short_description)
      expect(rendered).to include(image_tag(workshop.thumbnail_path))
      link_title = "The #{workshop.name} online workshop details"
      expect(rendered).
        to have_css("a[href='#{workshop_path(workshop)}'][title='#{link_title}']")
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

    def book_image_link(book)
      link_to(
        image_tag(book.image_url),
        book_path(book)
      )
    end
  end

  def assign_catalog(books: [], workshops: [], screencasts: [], mentors: [])
    assign(
      :catalog,
      stub(
        books: books,
        workshops: workshops,
        screencasts: screencasts,
        mentors: mentors
      )
    )
  end
end
