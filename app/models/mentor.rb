class Mentor
  def initialize(relation = User)
    @relation = relation
  end

  def featured
    @relation.mentors.sample(5)
  end
end
