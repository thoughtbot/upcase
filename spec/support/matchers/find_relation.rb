RSpec::Matchers.define :find_relation do |expected_relation|
  match do |actual_relation|
    actual_relation.respond_to?(:to_sql) &&
      expected_relation.respond_to?(:to_sql) &&
      actual_relation.to_sql == expected_relation.to_sql
  end

  failure_message do |actual_relation|
    expectation = eq(expected_relation.to_sql)
    match_expectation expectation, actual_relation
    expectation.failure_message
  end

  def match_expectation(expectation, actual_relation)
    if actual_relation.respond_to?(:to_sql)
      expectation.matches?(actual_relation.to_sql)
    else
      expectation.matches?(actual_relation)
    end
  end
end
