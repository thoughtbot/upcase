require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminPurchaseRefund
end
module RailsAdmin
  module Config
    module Actions
      class PurchaseRefund < RailsAdmin::Config::Actions::Base
        register_instance_option :visible? do
          authorized? && bindings && bindings[:object].respond_to?(:refund)
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-eye-open'
        end

        register_instance_option :controller do
          Proc.new do
            raise @object.inspect
          end
        end
      end
    end
  end
end
