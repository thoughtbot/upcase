require "rails_helper"

describe "shared/_analytics.html.erb" do
  include AnalyticsHelper

  context "when signed out" do
    before do
      view_stubs(signed_in?: false)
    end

    it "loads the Segment JavaScript library" do
      segment_load_line = %{window.analytics.load("#{ENV["SEGMENT_KEY"]}");}

      render

      expect(rendered).to include(segment_load_line)
    end

    it 'records a pageview' do
      record_pageview_line = %{window.analytics.page("", {"context":{"campaign":null}});}

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

  context "when signing up" do
    it "aliases the user id" do
      user_id = 123
      view_stubs(
        current_user: stub("user", id: user_id),
        flash: { purchase_amount: 29 },
        purchased_hash: "",
        signed_in?: false
      )

      render

      expect(rendered).to include(%{analytics.alias("#{user_id}")})
    end
  end

  context 'when signed in' do
    around(:each) do |example|
      ClimateControl.modify INTERCOM_API_SECRET: secret do
        example.run
      end
    end

    it 'identifies the user' do
      view_stubs(
        current_user: stub_everything('current user', id: 1),
        signed_in?: true
      )
      identify_line = 'analytics.identify('

      render

      expect(rendered).to include(identify_line)
    end

    it 'sends user data' do
      user = build_stubbed(:user)
      view_stubs(current_user: user, signed_in?: true)

      render

      expect(rendered).to include(identify_hash(user).to_json)
    end

    it 'uses Intercom secure mode' do
      user_id = 1
      view_stubs(
        current_user: stub_everything('current user', id: user_id),
        signed_in?: true
      )
      intercom_secure_mode = {
        'Intercom' => {
          userHash: OpenSSL::HMAC.hexdigest('sha256', secret, user_id.to_s)
        }
      }.to_json

      render

      expect(rendered).to include(intercom_secure_mode)
    end

    def secret
      'secret'
    end
  end
end
