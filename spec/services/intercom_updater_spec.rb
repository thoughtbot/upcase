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

    describe 'no user found' do
      let(:error_class) { Intercom::ResourceNotFound }

      before :each do
        Airbrake.stubs(:notify)
        Intercom::User.stubs(:find_by_email).with(user.email).raises(error_class.new)
      end

      it 'should notify' do
        updater = IntercomUpdater.new(user)
        updater.unsubscribe

        Airbrake.should have_received(:notify).with(instance_of(error_class))
      end
    end
  end
end
