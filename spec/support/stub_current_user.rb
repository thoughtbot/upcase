module StubCurrentUserHelper
  def stub_current_user_with(user)
    controller.stubs(:signed_in?).returns(true)
    controller.stubs(:current_user).returns(user)
  end
end
