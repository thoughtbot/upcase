require 'spec_helper'

describe PaymentsController do
  it "verifies the callback when requested" do
    client = stub
    client.stubs(:verify)
    client.stubs(:callback).returns(client)
    FreshBooks::Client.stubs(:new).returns(client)
    post :create, :name => "callback.verify", :object_id => 20, :verifier => "verifier string"
    client.should have_received(:verify).with(:callback_id => 20, :verifier => "verifier string")
  end
end
