module Responders
  class CheckoutResponder < ActionController::Responder
    include Responders::FlashResponder
    include Responders::HttpCacheResponder

    def initialize(controller, resource, options={})
      super
      @checkout = resource.first
      @controller = controller
    end

    def to_html
      if @checkout.save
        sign_in_checkout_user(@checkout)

        @controller.redirect_to(
          success_url,
          notice: @controller.t(
            "checkout.flashes.success",
            name: @checkout.subscribeable_name
          ),
          flash: {
            purchase_amount: @checkout.price,
            purchase_name: @checkout.subscribeable_name
          }
        )
      else
        @controller.render :new
      end
    end

    private

    def success_url
      @checkout.subscribeable.includes_team? ? @controller.edit_team_path : @controller.dashboard_path
    end

    def sign_in_checkout_user(checkout)
      if @controller.signed_out? && @checkout.user
        @controller.sign_in @checkout.user
      end
    end
  end
end
