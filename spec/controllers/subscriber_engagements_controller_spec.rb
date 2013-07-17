require 'spec_helper'

describe SubscriberEngagementsController, '#index' do
  include StubCurrentUserHelper

  it 'redirects to root when a user is not signed in' do
    get :index

    expect(response).to redirect_to root_path
  end

  it 'redirects to root when the user is not an admin' do
    user = create(:user)
    stub_current_user_with(user)

    get :index

    expect(response).to redirect_to root_path
  end

  it 'allows access when the user is an admin' do
    user = create(:admin)
    stub_current_user_with(user)

    get :index

    expect(response).to be_success
  end
end
