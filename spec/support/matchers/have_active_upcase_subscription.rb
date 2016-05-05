RSpec::Matchers.define :have_active_upcase_subscription do |plan|
  match do |user|
    user.subscription.present? && user.subscription.plan == plan
  end
end
