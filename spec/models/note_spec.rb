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

  context '#created_by?' do
    it 'returns true if the note was created by the passed in user' do
      user = create(:user)
      note = build(:note, contributor_id: user.id)

      expect(note.created_by?(user)).to be_true
    end

    it 'returns false if the note was created by the passed in user' do
      user = create(:user)
      id_of_another_user = 1234
      note = build(:note, contributor_id: id_of_another_user)

      expect(note.created_by?(user)).to be_false
    end
  end
end
