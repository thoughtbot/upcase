require 'sinatra/base'
require 'capybara_discoball'

if Rails.env == "test"
  module Paypal
    module NVP
      class Request < Base
        def self.endpoint=(endpoint)
          @@endpoint = endpoint
        end

        def self.endpoint
          @@endpoint
        end
      end
    end

    def self.endpoint=(endpoint)
      @@endpoint = endpoint
    end

    def self.endpoint
      @@endpoint
    end
  end
end

class FakePaypal < Sinatra::Base
  cattr_reader :outgoing_uri

  get '/*' do
    <<-HTML
    <form action="#{@@return_url}?token=1&PayerID=2">
      <input type="submit" value="Pay using Paypal">
    </form>
    HTML
  end

  post '/*' do
    @@outgoing_uri = url('?cmd=_express-checkout&token=')
    case params['METHOD']
    when 'SetExpressCheckout'
      @@return_url = params['RETURNURL']
      'ACK=Success'
    when 'DoExpressCheckoutPayment'
      @@token = params['TOKEN']
      @@payer_id = params['PAYERID']

      response = {
        TOKEN: "EC-8CG02550N02162351",
        SUCCESSPAGEREDIRECTREQUESTED: "false",
        TIMESTAMP: "2012-05-09T20:15:53Z",
        CORRELATIONID: "2fb4f865d272b",
        ACK: "Success",
        VERSION: "78.0",
        BUILD: "2860716",
        INSURANCEOPTIONSELECTED: "false",
        SHIPPINGOPTIONISDEFAULT: "false",
        PAYMENTINFO_0_TRANSACTIONID: "2UK612144H7301328",
        PAYMENTINFO_0_TRANSACTIONTYPE: "cart",
        PAYMENTINFO_0_PAYMENTTYPE: "instant",
        PAYMENTINFO_0_ORDERTIME: "2012-05-09T20:15:51Z",
        PAYMENTINFO_0_AMT: "15.00",
        PAYMENTINFO_0_FEEAMT: "0.74",
        PAYMENTINFO_0_TAXAMT: "0.00",
        PAYMENTINFO_0_CURRENCYCODE: "USD",
        PAYMENTINFO_0_PAYMENTSTATUS: "Completed",
        PAYMENTINFO_0_PENDINGREASON: "None",
        PAYMENTINFO_0_REASONCODE: "None",
        PAYMENTINFO_0_PROTECTIONELIGIBILITY: "Eligible",
        PAYMENTINFO_0_PROTECTIONELIGIBILITYTYPE: "ItemNotReceivedEligible, UnauthorizedPaymentEligible",
        PAYMENTINFO_0_SECUREMERCHANTACCOUNTID: "KGUCX4PWLFHYW",
        PAYMENTINFO_0_ERRORCODE: "0",
        PAYMENTINFO_0_ACK: "Success"
      }

      response.inject('') {|acc,(k,v)| "#{acc}&#{k}=#{v}"}
    end
  end
end

FakePaypalRunner = Capybara::Discoball.spin(FakePaypal) do |server|
  url = server.url('/')
  Paypal::NVP::Request.endpoint = url
  Paypal.endpoint = url
end
