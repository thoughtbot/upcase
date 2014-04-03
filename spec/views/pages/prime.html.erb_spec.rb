require 'spec_helper'

describe 'pages/prime.html.erb' do
  context 'when signed in' do
    it 'includes a sign out link' do
      view_stubs(:signed_in?).returns(true)

      render_template

      expect(rendered).
        to include(link_to('Sign out', sign_out_path, method: :delete))
    end

    it 'includes an account link' do
      view_stubs(:signed_in?).returns(true)

      render_template

      expect(rendered).to include(link_to('Account', my_account_path))
    end

    it 'does not include a sign in link' do
      view_stubs(:signed_in?).returns(true)

      render_template

      expect(rendered).not_to include(link_to('Sign in', sign_in_path))
    end
  end

  context 'when signed out' do
    it 'includes a sign in link' do
      view_stubs(:signed_in?).returns(false)

      render_template

      expect(rendered).to include(link_to('Sign in', sign_in_path))
    end

    it 'does not include a sign out link' do
      view_stubs(:signed_in?).returns(false)

      render_template

      expect(rendered).
        not_to include(link_to('Sign out', sign_out_path, method: :delete))
    end

    it 'does not include an account link' do
      view_stubs(:signed_in?).returns(false)

      render_template

      expect(rendered).not_to include(link_to('Account', my_account_path))
    end
  end

  def render_template
    render template: 'pages/prime.html.erb'
  end
end
