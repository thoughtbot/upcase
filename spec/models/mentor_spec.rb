require 'spec_helper'

describe Mentor do
  describe '#featured' do
    it 'executes queries on the relation' do
      mentors = stub('mentors', :sample)
      relation = stub('relation', mentors: mentors)

      Mentor.new(relation).featured

      expect(mentors).to have_received(:sample).with(Mentor::NUMBER_OF_MENTORS_TO_FEATURE)
    end
  end
end
