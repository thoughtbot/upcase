class NewLanguageConfirmationsController < ApplicationController
  def index
    redirect_to welcome_to_upcase_path(
      confirmation: true, language_selected: params[:language],
    ), notice: "Thanks for signing up. We will be in touch!"
  end
end
