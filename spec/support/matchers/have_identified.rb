RSpec::Matchers.define :have_identified do |user|
  match do |backend|
    @backend = backend

    backend
      .identified_events_for(user)
      .has_properties?(@properties || {})
  end

  chain(:with_properties) { |properties| @properties = properties }
end
