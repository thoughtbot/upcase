class SubscriptionMailer < BaseMailer
  def welcome_to_prime(user)
    @user = user
    @mentor = user.mentor

    mail(
      to: @user.email,
      subject: "Welcome to Prime! I'm your new mentor",
      from: "#{@mentor.name} <#{@mentor.email}>"
    )
  end
end
