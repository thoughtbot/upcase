require 'spec_helper'

describe Timeline, '#grouped_timeline_items' do
  it 'returns notes and completions in hashes grouped by week' do
    user = create(:user)
    timeline = Timeline.new(user)

    completion = create(:completion, user: user, slug: 'whatever')
    note = create(:note, user: user)

    beginning_of_week = completion.created_at.beginning_of_week
    expect(timeline.grouped_items).to eq(
      { beginning_of_week => { completions: [completion], notes: [note] } }
    )
  end

  it 'returns only the users completions and no others' do
    user = create(:user)
    another_user = create(:user)
    create(:completion, user: another_user, slug: 'whatever')
    timeline = Timeline.new(user)

    completion = create(:completion, user: user, slug: 'whatever')

    beginning_of_week = completion.created_at.beginning_of_week
    expect(timeline.grouped_items).to eq(
      { beginning_of_week => { completions: [completion] } }
    )
  end

  it 'returns items sorted DESC by creation_date' do
    user = create(:user)
    timeline = Timeline.new(user)

    oldest_item = create(:completion, user: user, slug: 'whatever', trail_object_id: '1')
    middle_item = create(:completion, user: user, slug: 'whatever', trail_object_id: '2')
    newest_item = create(:completion, user: user, slug: 'whatever', trail_object_id: '3')

    beginning_of_week = oldest_item.created_at.beginning_of_week
    expect(timeline.grouped_items).to eq(
      { beginning_of_week =>  { completions: [newest_item, middle_item, oldest_item] } }
    )
  end
end

describe Timeline, '#has_items?' do
  it 'returns true when there are items in the timeline' do
    user = create(:user)
    timeline = Timeline.new(user)

    completion = create(:completion, user: user, slug: 'whatever')

    expect(timeline.has_items?).to be_true
  end

  it 'returns false when there are no items in the timeline' do
    user = create(:user)

    timeline = Timeline.new(user)

    expect(timeline.has_items?).to be_false
  end
end
