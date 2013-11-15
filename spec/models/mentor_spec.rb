require 'spec_helper'

describe Mentor do
  describe '#featured' do
    it 'executes queries on the relation' do
      mentors = stub('mentors', :sample)
      relation = stub('relation', mentors: mentors)

      Mentor.new(relation).featured

      expect(mentors).to have_received(:sample).with(5)
    end
  end
end
