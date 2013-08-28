require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class Timeline < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :only do
          'User'
        end

        register_instance_option :member do
          true
        end

        register_instance_option :controller do
          Proc.new do
            redirect_to main_app.user_timeline_path(@object)
          end
        end

        register_instance_option :link_icon do
          'icon-eye-open'
        end

        register_instance_option :pjax? do
          false
        end
      end
    end
  end
end
