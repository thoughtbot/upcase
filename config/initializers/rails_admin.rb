PAGE_TITLE_HELP = "Text for the <title> tag.".freeze
META_DESCRIPTION_HELP = %(Text for the <meta name="Description"> tag.).freeze
DESCRIPTION_HELP = "Short primary description, always shown".freeze
EXTENDED_DESCRIPTION_HELP = <<-DESC.strip_heredoc.freeze
  Detailed additional description. Hidden on initial render,
  but available by clicking 'Read more' link.
DESC
TEAM_CONVERSION_HELP = <<-DESC.strip_heredoc.freeze
  Submitting a new team name will create a team with this user as owner
DESC

RailsAdmin.config do |config|
  config.asset_source = :sprockets
  config.authorize_with do
    unless current_user.admin?
      redirect_to(
        main_app.root_path,
        alert: "You are not authorized to access that page"
      )
    end
  end

  config.excluded_models = ["ActiveStorage::Blob", "ActiveStorage::Attachment"]

  config.current_user_method { current_user }

  config.main_app_name = ["Upcase", "Admin"]

  config.parent_controller = "::ApplicationController"

  config.actions do
    init_actions!
  end

  config.model "Show" do
    list do
      field :name
      field :slug
    end

    edit do
      field :name
      field :slug

      group :seo do
        field :meta_description do
          help META_DESCRIPTION_HELP
        end
        field :page_title do
          help PAGE_TITLE_HELP
        end
        field :tagline
      end
    end
  end

  config.model "User" do
    list do
      field :id
      field :name
      field :email
      field :github_username
      field :masquerade do
        pretty_value do
          bindings[:view].link_to(
            "Masquerade",
            bindings[:view].main_app.user_masquerade_path(bindings[:object]),
            method: :post
          )
        end
      end
    end

    edit do
      field :email
      field :name
      field :admin
      field :bio
      field :github_username

      group :convert_to_team do
        field :team_name do
          help TEAM_CONVERSION_HELP
        end
      end
    end
  end

  config.model "Product" do
    list do
      field :id
      field :name
      field :sku
      field :type

      sort_by :name
    end
  end

  config.model "Exercise" do
    list do
      field :id
      field :name
    end

    edit do
      field :whetstone_edit_url do
        label false
        help false
        partial "whetstone_edit_url"
      end

      field :trail
    end
  end

  config.model "Trail" do
    list do
      field :id
      field :name
      field :published
    end

    edit do
      include_all_fields

      group :seo do
        field :description do
          help DESCRIPTION_HELP
        end
        field :extended_description do
          help EXTENDED_DESCRIPTION_HELP
        end
        field :meta_description do
          help META_DESCRIPTION_HELP
        end
        field :page_title do
          help PAGE_TITLE_HELP
        end
      end

      field :steps do
        orderable true
      end

      exclude_fields :exercises, :videos, :statuses, :users
    end
  end

  config.model "Video" do
    list do
      field :id

      field :watchable do
        label "Product name"

        pretty_value do
          value.name
        end
      end

      field :name
      field :created_at
    end

    edit do
      group :default do
        field :name
        field :slug
        field :summary
        field :notes
        field :topics

        field :watchable do
          partial "form_watchable_association"
        end

        field :position
        field :published_on
        field :users
        field :length_in_minutes
        field :markers
      end

      group :weekly_iteration do
        field :email_subject
        field :email_body_text
        field :email_cta_label
      end

      group :seo do
        field :meta_description do
          help META_DESCRIPTION_HELP
        end
        field :page_title do
          help PAGE_TITLE_HELP
        end
        field :summary do
          help "Shown on TWI index page"
        end
      end

      group :wistia do
        field :wistia_id
        field :preview_wistia_id
      end
    end
  end

  config.model "Marker" do
    field :video
    field :anchor
    field :time do
      label "Time (seconds)"
    end
  end

  config.model "Topic" do
    list do
      field :name
      field :slug
    end

    edit do
      field :name
      field :slug

      group :seo do
        field :extended_description do
          help EXTENDED_DESCRIPTION_HELP
        end
        field :meta_description do
          help META_DESCRIPTION_HELP
        end
        field :page_title do
          help PAGE_TITLE_HELP
        end
        field :summary do
          help DESCRIPTION_HELP
        end
      end
    end
  end
end
