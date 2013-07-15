require 'spec_helper'

describe PurchasesHelper, '#formatted_date_range' do
  context 'when starts_on and ends_on are nil' do
    it 'returns nil' do
      expect(formatted_date_range(nil, nil)).to be_nil
    end
  end

  context 'when starts_on == ends_on' do
    it 'returns a string representation of a single date' do
      date = Date.parse('20121102')

      expect(formatted_date_range(date, date)).to eq 'November 02, 2012'
    end
  end

  context 'when starts_on and ends_on are different years' do
    it 'includes month and year in both dates' do
      starts_on = Date.parse('20121102')
      ends_on = Date.parse('20131102')

      expect(formatted_date_range(starts_on, ends_on)).
        to eq 'November 02, 2012-November 02, 2013'
    end
  end

  context 'when starts_on and ends_on are different months' do
    it 'does not repeat the year' do
      starts_on = Date.parse('20121102')
      ends_on = Date.parse('20121202')

      expect(formatted_date_range(starts_on, ends_on)).
        to eq 'November 02-December 02, 2012'
    end
  end

  context 'when starts_on and ends_on are different days' do
    it 'does not repeat the month or year' do
      starts_on = Date.parse('20121102')
      ends_on = Date.parse('20121103')

      expect(formatted_date_range(starts_on, ends_on)).
        to eq 'November 02-03, 2012'
    end
  end
end
