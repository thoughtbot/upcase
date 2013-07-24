class PurchaseMailer < BaseMailer
  def welcome_to_prime(user)
    @user = user
    @mentor = user.mentor

    mail(
      to: @user.email,
      subject: "Welcome to Prime! I'm your new mentor",
      from: "#{@mentor.name} <#{@mentor.email}>"
    )
  end

  def follow_up(follow_up, section)
    @section = section

    mail(
      to: follow_up.email,
      subject: "The #{@section.workshop.name} workshop has been scheduled"
    )
  end
end
