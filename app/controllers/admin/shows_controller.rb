module Admin
  class ShowsController < Admin::ApplicationController
    def find_resource(param)
      Show.find_by!(slug: param)
    end
  end
end
