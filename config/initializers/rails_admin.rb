require 'rails_admin/config/actions/purchase_accounting'
require 'rails_admin/config/actions/timeline'

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

  config.main_app_name = ['Learn', 'Admin']

  config.yell_for_non_accessible_fields = false

  config.actions do
    init_actions!
    purchase_refund
    purchase_accounting
    timeline
  end

  config.model Mentor do
    list do
      field :name
      field :accepting_new_mentees
      field :active_mentee_count do
        label 'Mentees'
      end
      field :availability
    end

    show do
      field :user
      field :accepting_new_mentees
      field :availability
      field :active_mentees do
        pretty_value do
          value.map do |user|
            bindings[:view].link_to(
              user.name,
              bindings[:view].url_for(:model_name => 'user', :id => user.to_param),
              :class => 'pjax'
            )
          end.to_sentence.html_safe
        end
      end
    end

    edit do
      field :user
      field :accepting_new_mentees
      field :availability
    end
  end

  config.model User do
    list do
      field :id
      field :name
      field :email
      field :github_username
      field :subscription
    end

    edit do
      field :email
      field :name
      field :admin
      field :bio
      field :github_username
      field :mentor
      field :paid_purchases
      field :purchases
      field :subscription
      field :stripe_customer_id
    end
  end

  config.model Product do
    list do
      field :id
      field :name
      field :sku
      field :product_type
      field :individual_price
      field :company_price
    end
  end

  config.model Workshop do
    list do
      field :name
      field :active
    end

    edit do
      group :default do
        field :name
        field :sku
        field :short_description
        field :description
        field :active
        field :topics
        field :resources
        field :terms
        field :length_in_days
      end

      group :faq do
        label 'FAQ'
        field :questions
      end

      group :videos do
        field :videos
      end
    end
  end

  config.model Purchase do
    object_label_method { :purchase_label_method }

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

    edit do
      configure :created_at do
        visible
      end
    end
  end

  def purchase_label_method
    "Purchase #{self.id} (#{self.purchaseable_name})"
  end
end
