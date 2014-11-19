RSpec::Matchers.define :have_tracked do |event_name|
  match do |backend|
    @event_name = event_name
    @backend = backend

    backend.
      tracked_events_for(@user).
      named(@event_name).
      has_properties?(@properties || {})
  end

  chain(:for_user) { |user| @user = user }
  chain(:with_properties) { |properties| @properties = properties }
end
