require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class SectionStudents < Base
        register_instance_option(:only){ 'Section' }
        register_instance_option(:member?){ true }
        register_instance_option(:link_icon){ 'icon-user' }
        register_instance_option(:controller) do
          Proc.new do
            @section = @object
            render action: @action.template_name
          end
        end
      end

      register SectionStudents
    end
  end
end
