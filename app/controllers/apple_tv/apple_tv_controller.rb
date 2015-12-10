module AppleTv
  class AppleTvController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show

    end
  end
end
