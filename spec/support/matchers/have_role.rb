RSpec::Matchers.define :have_role do |role_name, options|
  match do |page|
    page.has_css? "[data-role='#{role_name}']", options
  end
end
