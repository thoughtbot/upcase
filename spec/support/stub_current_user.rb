module StubCurrentUserHelper
  def stub_current_user_with(user)
    allow(controller).to receive(:signed_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end
end
