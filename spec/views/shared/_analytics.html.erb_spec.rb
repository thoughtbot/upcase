require 'spec_helper'

describe 'shared/_analytics.html.erb' do
  context 'when signed out' do
    before do
      view_stubs(signed_in?: false)
    end

    it 'loads the Segment.io JavaScript library' do
      segment_load_line = "window.analytics.load(#{ENV['SEGMENT_KEY']});"

      render

      expect(rendered).to include(segment_load_line)
    end

    it 'records a pageview' do
      record_pageview_line = 'window.analytics.page();'

      render

      expect(rendered).to include(record_pageview_line)
    end

    it 'does not load user-specific analytics' do
      render

      expect(rendered).to have_received(:render).
        with('shared/signed_in_analytics').
        never
    end
  end

  context 'when signed in' do
    around(:each) do |example|
      ClimateControl.modify INTERCOM_API_SECRET: secret do
        example.run
      end
    end

    before(:each) do
      view_stubs(
        current_user: stub_everything('current user', id: current_user_id),
        signed_in?: true
      )
    end

    it 'identifies the user' do
      identify_line = 'analytics.identify('

      render

      expect(rendered).to include(identify_line)
    end

    it 'records current properties of user' do
      user_properties = {
        created: nil,
        email: nil,
        has_active_subscription: nil,
        has_logged_in_to_forum: nil,
        mentor_name: nil,
        name: nil,
        plan: nil,
        subscribed_at: nil,
        username: nil
      }.to_json

      render

      expect(rendered).to include(user_properties)
    end

    it 'uses Intercom secure mode' do
      intercom_secure_mode = {
        'Intercom' => {
          userHash: OpenSSL::HMAC.hexdigest('sha256', secret, current_user_id.to_s)
        }
      }.to_json

      render

      expect(rendered).to include(intercom_secure_mode)
    end

    def secret
      'secret'
    end

    def current_user_id
      1
    end
  end
end
