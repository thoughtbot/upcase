require 'spec_helper'

describe WorkshopsHelper, '#workshop_frequency_note' do
  context 'an workshop that starts immediately' do
    it 'says how often it is offered' do
      workshop = stub(online?: true, starts_immediately?: true)

      note = workshop_frequency_note(workshop)

      expect(note).to include 'as soon as you register'
    end
  end

  context 'a workshop that does not start immediately' do
    it 'says how often it is offered' do
      workshop = stub(online?: true, starts_immediately?: false)

      note = workshop_frequency_note(workshop)

      expect(note).to include 'six weeks'
    end
  end
end
