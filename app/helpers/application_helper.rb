module ApplicationHelper
  def body_class
    qualified_controller_name = controller.controller_path.gsub('/','-')
    "#{qualified_controller_name} #{qualified_controller_name}-#{controller.action_name}"
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
    new_section_purchase_path(section, variant: :individual)
  end

  def github_auth_path
    '/auth/github'
  end

  def format_resources(resources)
    BlueCloth.new(resources).to_html
  end

  def partial_name(model)
    File.basename(model.to_partial_path)
  end

  def forum_url(suffix=nil)
    "http://forum.upcase.com/#{suffix}"
  end

  def blog_articles_url(topic)
    "http://robots.thoughtbot.com/tags/#{topic.slug}"
  end

  def current_user_has_access_to?(feature)
    current_user && current_user.has_access_to?(feature)
  end
end
