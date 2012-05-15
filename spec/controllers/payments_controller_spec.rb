require 'spec_helper'

describe PaymentsController do
  it "verifies the callback when requested" do
    client = stubbed_freshbooks_client
    post :create, name: "callback.verify", callback_id: 20, verifier: "verifier string"
    client.should have_received(:verify).with(callback_id: "20", verifier: "verifier string")
  end

  it "sends the 'Paid' event to KISSmetrics on payment.create" do
    registration = Factory(:registration, freshbooks_invoice_id: "invoice123")

    client = stubbed_freshbooks_client
    payment = stubbed_payment_for(registration)

    stub_payment_get_response_for(client, payment)

    post :create, name: "payment.create", object_id: "abc123"

    course_name = registration.section.course_name
    FakeKissmetrics.events_for(registration.email).should include "Paid"
    FakeKissmetrics.properties_for(registration.email, "Paid").should include({ "Course Name" => course_name })
  end

  def stubbed_freshbooks_client
    stub("Freshbooks client").tap do |client|
      client.stubs(:verify)
      client.stubs(:callback).returns(client)
      FreshBooks::Client.stubs(:new).returns(client)
    end
  end

  def stubbed_payment_for(registration)
    stub("payment").tap do |payment|
      payment.stubs(:[]).with("invoice_id").returns(registration.freshbooks_invoice_id)
    end
  end

  def stub_payment_get_response_for(client, payment)
    payment_get_response = stub("Freshbooks payment.get response")
    payment_get_response.stubs(:[]).with("payment").returns(payment)
    client.stubs(payment: stub(get: payment_get_response))
  end
end
