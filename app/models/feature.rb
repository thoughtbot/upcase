class Feature < ActiveRecord::Base
  WORKSHOPS_KEY = 'workshops'.freeze
  MENTORING_KEY = 'mentoring'.freeze

  belongs_to :plan, polymorphic: true
end
