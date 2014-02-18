require 'spec_helper'

describe IntercomUpdater do
  describe 'unsubscribe' do
    let(:user) { create(:user) }

    before :each do
      custom_data = { 'has_active_subscription' => true }
      intercom_user = stub(save: true, custom_data: custom_data)
      Intercom::User.stubs(:find_by_email).with(user.email).returns(intercom_user)
    end

    it 'should unsubscribe user' do
      updater = IntercomUpdater.new(user)
      updater.unsubscribe

      expect(Intercom::User).to have_received(:find_by_email).with(user.email)
      intercom_user = Intercom::User.find_by_email(user.email)
      expect(intercom_user).to have_received(:custom_data)
      expect(intercom_user).to have_received(:save)
      expect(intercom_user.custom_data['has_active_subscription']).to eq(false)
    end
  end
end
