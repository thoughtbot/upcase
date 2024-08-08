class AcceptancesController < ApplicationController
  def new
    @invitation = Invitation.find(params[:invitation_id])

    if signed_in?
      if @invitation.accept(current_user)
        redirect_to(
          practice_path,
          notice: "You've been added to the team. Enjoy!"
        )
      else
        flash[:error] = t(".invitation_taken")
        render :new
      end
    else
      session[:invitation_id] = params[:invitation_id]
      render :new
    end
  end
end
