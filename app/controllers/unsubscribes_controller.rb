class UnsubscribesController < ApplicationController
  include UnsubscribesHelper

  UNSUBSCRIBE_ERRORS = [
    ActiveRecord::RecordNotFound,
    ActiveSupport::MessageVerifier::InvalidSignature
  ].freeze

  def show
    user = find_user_by_token
    unsubscribe_user(user)
  rescue *UNSUBSCRIBE_ERRORS
    render :error, status: :unprocessable_entity
  end

  private

  def unsubscribe_user(user)
    user.update! unsubscribed_from_emails: true
  end

  def find_user_by_token
    user_id_from_token = unsubscribe_token_verifier.verify(params[:token])
    User.find user_id_from_token
  end
end
