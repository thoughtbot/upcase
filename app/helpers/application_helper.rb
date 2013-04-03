module ApplicationHelper
  def body_class
    qualified_controller_name = controller.controller_path.gsub('/','-')
    "#{qualified_controller_name} #{qualified_controller_name}-#{controller.action_name}"
  end

  def format_date_range(range)
    range
  end

  def google_map_link_to(address, *options, &block)
    google_link = "http://maps.google.com/maps?f=q&q=#{CGI.escape(address)}&z=17&iwloc=A"
    if block_given?
      link_to(capture(&block), google_link, *options)
    else
      link_to address, google_link, *options
    end
  end

  def keywords(keywords = nil)
    keywords.presence || Topic.top.pluck(:name).join(', ')
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, 'remove_fields(this)')
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + '_fields', :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def registration_url(section)
    if section.workshop.external_registration_url.blank?
      new_section_purchase_path(section, variant: :individual)
    else
      section.workshop.external_registration_url
    end
  end

  def github_auth_path
    '/auth/github'
  end

  def format_podcast_notes(notes)
    BlueCloth.new(notes).to_html
  end

  def format_resources(resources)
    BlueCloth.new(resources).to_html
  end

  def partial_name(model)
    model.class.name.downcase
  end
end
