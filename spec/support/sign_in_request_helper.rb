module SignInRequestHelpers
  def sign_in_as(user)
    post(
      "/session",
      session: {
        email: user.email,
        password: user.password,
      },
    )
  end
end
