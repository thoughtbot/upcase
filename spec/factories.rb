Factory.define(:course) do |course_factory|
end

Factory.define(:section) do |section_factory|
  section_factory.association :course
end
