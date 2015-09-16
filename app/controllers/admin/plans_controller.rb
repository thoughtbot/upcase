module Admin
  class PlansController < Admin::ApplicationController
    def find_resource(param)
      Plan.find_by!(sku: param)
    end
  end
end
