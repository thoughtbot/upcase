module Admin
  class RepositoriesController < Admin::ApplicationController
    def find_resource(param)
      Repository.find_by!(slug: param)
    end
  end
end
