require 'spec_helper'

describe Note do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:contributor).class_name('User') }
  end

  context 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:contributor_id) }
  end

  context '#body_html' do
    it 'renders body as markdown' do
      note = build(:note,  body: 'Some *awesome* markdown')

      expect(note.body_html).to eq '<p>Some <em>awesome</em> markdown</p>'
    end
  end
end
