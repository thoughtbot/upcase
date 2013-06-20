class BytesController < ApplicationController
  def index
    @bytes = Byte.ordered.published
  end

  def show
    @byte = Byte.find(params[:id])
    if current_user_has_access_to_bytes?
      if !@byte.published? && !current_user_is_admin?
        deny_access
      end
    else
      redirect_to subscription_product, notice: t('shared.subscriptions.protected_content')
    end
  end

  private

  def url_after_denied_access_when_signed_in
    sign_in_path
  end

  def current_user_has_access_to_bytes?
    current_user_has_active_subscription? || current_user_is_admin?
  end
end
