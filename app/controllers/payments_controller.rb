class PaymentsController < ApplicationController
  before_filter :verify_callback, if: :callback_request?

  def create
    p params
    if params[:name] == "payment.create"
      payment = get_freshbooks_payment(params[:object_id])["payment"]
      if registration = Registration.find_by_freshbooks_invoice_id(payment["invoice_id"])
        registration.receive_payment!
        km_http_client.record(registration.email, "Paid", { "Course Name" => registration.section.course_name })
      end
    end
    head :created
  end

  protected

  def get_freshbooks_payment(payment_id)
    freshbooks_client.payment.get(payment_id: payment_id)
  end

  def freshbooks_client
    @freshbooks_client ||= FreshBooks::Client.new(FRESHBOOKS_PATH, FRESHBOOKS_TOKEN)
  end

  def callback_request?
    params[:name] == "callback.verify"
  end

  def verify_callback
    freshbooks_client.callback.verify(callback_id: params[:callback_id], verifier: params[:verifier])
    head :created
  end
end
