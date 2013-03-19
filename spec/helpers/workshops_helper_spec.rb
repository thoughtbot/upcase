require 'spec_helper'

describe WorkshopsHelper, '#workshop_frequency_note' do
  context 'an online workshop' do
    it 'says how often it is offered' do
      workshop = build(:online_workshop)

      note = workshop_frequency_note(workshop)

      expect(note).to include 'every month'
    end
  end

  context 'an in person workshop' do
    it 'says how often it is offered' do
      workshop = build(:workshop)

      note = workshop_frequency_note(workshop)

      expect(note).to include 'about every six weeks'
    end
  end
end
