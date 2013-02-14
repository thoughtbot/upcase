require 'rails_admin/config/actions/purchase_accounting'
require 'rails_admin/config/actions/section_students'

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
    section_students
  end

  config.model Article do
    list do
      field :title
      field :draft
      field :published_on
    end

    edit do
      group :default do
        field :title
        field :body
        field :draft
        field :published_on
        field :topics
      end

      group :extras do
        active false
        field :external_url
        field :body_html
      end
    end
  end

  config.model Workshop do
    list do
      field :name
      field :sections do
        pretty_value do
          bindings[:view].render 'rails_admin/sections/list',
            sections: value, workshop: bindings[:object]
        end
      end
    end

    edit do
      group :default do
        field :name
        field :online
        field :short_description
        field :description
        field :individual_price
        field :company_price
        field :alternate_individual_price
        field :alternate_company_price
        field :maximum_students
        field :external_registration_url
        field :public
        field :start_at
        field :stop_at
        field :video_chat_url
        field :promo_location
        field :topics
        field :resources
      end

      group :events do
        field :events
      end

      group :faq do
        label 'FAQ'
        field :questions
      end

      group :follow_ups do
        field :follow_ups
      end
    end
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

  config.model Section do
    object_label_method { :date_range }

    list do
      field :workshop
      field :starts_on
      field :ends_on
    end

    edit do
      group :dates do
        field :starts_on
        field :ends_on
        field :start_at
        field :stop_at
      end

      group :address do
        field :address
        field :city
        field :state
        field :zip
      end

      group :details do
        field :workshop
        field :seats_available
        field :reminder_email
        field :teachers
      end
    end
  end
end
