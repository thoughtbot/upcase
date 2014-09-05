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

  config.main_app_name = ['Upcase', 'Admin']

  config.yell_for_non_accessible_fields = false

  config.actions do
    init_actions!
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

    object_label_method do
      :id
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
      field :licenses
      field :stripe_customer_id
    end
  end

  config.model Product do
    list do
      field :id
      field :name
      field :sku
      field :type
      field :individual_price
      field :company_price
    end
  end

  config.model VideoTutorial do
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
        field :promoted
        field :topics
        field :resources
        field :terms
        field :length_in_days
        field :github_team
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
end
