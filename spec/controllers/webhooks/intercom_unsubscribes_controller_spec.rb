require "rails_helper"

describe Webhooks::IntercomUnsubscribesController do
  describe "#create" do
    context "with an valid signature" do
      it "should unsubscribe the user" do
        user = create(:user, unsubscribed_from_emails: false)
        payload = build_payload(user)
        set_valid_signature_header_for(payload)

        post :create, payload

        expect(user.reload).to be_unsubscribed_from_emails
      end

      it "should return a success status code" do
        user = create(:user, unsubscribed_from_emails: false)
        payload = build_payload(user)
        set_valid_signature_header_for(payload)

        post :create, payload

        expect(response).to have_http_status(:success)
      end
    end

    context "with an invalid signature" do
      it "should notify honey badger" do
        allow(Honeybadger).to receive(:notify)
        set_incorrect_signature_header

        post :create, build_payload

        expect(Honeybadger).to have_received(:notify)
      end

      it "should respond with an error status" do
        set_incorrect_signature_header

        post :create, build_payload

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when unable to find the user" do
      it "should notify honey badger" do
        allow(Honeybadger).to receive(:notify)
        payload = unknown_user_payload
        set_valid_signature_header_for(payload)

        post :create, payload

        expect(Honeybadger).to have_received(:notify)
      end

      it "should respond with an error status" do
        payload = unknown_user_payload
        set_valid_signature_header_for(payload)

        post :create, payload

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  def set_valid_signature_header_for(payload)
    set_signature_header("sha1=#{signature_for(payload)}")
  end

  def signature_for(data)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha1"), intercom_secret, data)
  end

  def intercom_secret
    ENV.fetch("INTERCOM_WEBHOOK_SECRET")
  end

  def set_incorrect_signature_header
    set_signature_header("not-real")
  end

  def set_signature_header(value)
    @request.headers["X-Hub-Signature"] = value
  end

  def unknown_user_payload
    build_payload(double("User", id: "not-a-known-id"))
  end

  def build_payload(user = create(:user))
    body = {
      "type" => "notification_event",
      "topic" => "user.unsubscribed",
      "data" => {
        "type" => "notification_event_data",
        "item" => {
          "type" => "user",
          "user_id" => user.id,
        },
      },
    }
    body.to_json
  end
end
