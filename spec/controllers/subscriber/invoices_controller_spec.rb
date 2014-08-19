require "rails_helper"

describe Subscriber::InvoicesController do
  context "index" do
    it_behaves_like "must be subscription owner" do
      def perform_request
        get :index
      end

      def authorize
        respond_with(:success)
      end
    end
  end

  context "show" do
    it_behaves_like "must be subscription owner" do
      def perform_request
        get :show, id: "in_1s4JSgbcUaElzU"
      end

      def authorize
        respond_with(:success)
      end
    end
  end
end
