class NewLanguageConfirmationsController < ApplicationController
  def index
    redirect_to root_path, notice: t("marketing.show.language_flash")
  end
end
