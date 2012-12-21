require 'rails_admin/config/actions/purchase_accounting'

module RailsAdmin
  module Config
    module Actions
      class PurchaseRefund < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
      end
    end
  end
end

RailsAdmin.config do |config|
  config.authenticate_with do
    unless current_user
      session[:return_to] = request.url
      redirect_to "/sign_in", :alert => "You must first log in or sign up before accessing this page."
    end
  end

  config.authorize_with do
    redirect_to "/", :alert => "You are not authorized to access that page" unless current_user.admin?
  end

  config.current_user_method { current_user }

  config.main_app_name = ['Workshops', 'Admin']

  config.actions do
    init_actions!
    purchase_refund
    purchase_accounting
  end

  config.model Purchase do
    list do
      field :purchaseable_id do
        visible true
        filterable true
      end
      field :purchaseable_type do
        visible true
        filterable true
      end
      include_all_fields
    end

    export do
      field :purchaseable_name do
        visible true
        filterable true
      end
      field :price do
        visible true
        filterable true
      end
      field :created_at do
        export_value { value.to_s }
      end
      include_all_fields
    end
  end
end
