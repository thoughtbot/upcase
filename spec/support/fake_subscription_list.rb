class FakeSubscriptionList < Array
  alias_method :total_count, :size
end
