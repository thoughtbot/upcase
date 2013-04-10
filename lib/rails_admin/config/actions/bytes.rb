require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class Bytes < Index
        register_instance_option(:only){ 'Article' }
        register_instance_option :action_name do
          :bytes
        end
        register_instance_option :route_fragment do
          :bytes
        end
        register_instance_option :sort_by do
          :published_on
        end

        register_instance_option :controller do
          Proc.new do
            @objects ||= list_entries.bytes

            respond_to do |format|
              format.html do
                render @action.template_name, :status => (flash[:error].present? ? :not_found : 200)
              end
            end
          end
        end
      end

      register Bytes
    end
  end
end
