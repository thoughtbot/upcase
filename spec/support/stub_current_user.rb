module StubCurrentUserHelper
  def stub_current_user_with(user)
    controller.stubs(:current_user).returns(user)
  end
end
