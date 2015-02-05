require "rails_helper"

describe Subscriber::InvoicesController do
  context "index" do
    it "unauthenticated visitor can't access" do
      get :index

      expect(response).to be_redirect
    end

    it "signed in user can access index" do
      sign_in

      get :index

      expect(response).to be_success
    end
  end

  context "show" do
    context "signed in user" do
      it "unauthenticated visitor can't access" do
        get :show, id: FakeStripe::INVOICE_ID

        expect(response).to be_redirect
      end
    end

    context "signed in user" do
      context "when an invoice is fetched" do
        context "and its customer id matches the users customer id" do
          it "renders successfully" do
            user = build_stubbed(
              :subscriber,
              stripe_customer_id: FakeStripe::CUSTOMER_ID
            )
            invoice = double(user: user)
            allow(Invoice).to receive(:new).and_return(invoice)
            sign_in_as user

            get :show, id: FakeStripe::INVOICE_ID

            expect(response).to be_success
          end
        end

        context "and its customer id does not match the users customer id" do
          it "denies access" do
            user = build_stubbed(
              :subscriber,
              stripe_customer_id: "bad-stripe-customer-id"
            )
            sign_in_as user

            expect do
              get :show, id: FakeStripe::INVOICE_ID
            end.to raise_exception(ActionController::RoutingError)
          end
        end
      end

      context "when invoice doesn't exist in Stripe" do
        it "denies access" do
          user = build_stubbed(
            :subscriber,
            stripe_customer_id: "bad-stripe-customer-id"
          )
          sign_in_as user

          expect do
            get :show, id: "bad-stripe-invoice-id"
          end.to raise_exception(ActionController::RoutingError)
        end
      end
    end
  end
end
