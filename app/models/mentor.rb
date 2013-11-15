class Mentor
  NUMBER_OF_MENTORS_TO_FEATURE = 2
  def initialize(relation = User)
    @relation = relation
  end

  def featured
    @relation.mentors.sample(NUMBER_OF_MENTORS_TO_FEATURE)
  end
end
