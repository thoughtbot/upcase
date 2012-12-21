require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class PurchaseAccounting < Base
        register_instance_option(:only){ 'Purchase' }
        register_instance_option(:collection?){ true }
      end

      register PurchaseAccounting
    end
  end
end
