require 'spec_helper'

describe Timeline, '#grouped_items' do
  it 'returns notes and completions in a hash grouped by week' do
    user = create(:user)
    timeline = Timeline.new(user)

    completion = create(:completion, user: user, slug: 'whatever')
    note = create(:note, user: user)

    beginning_of_week = completion.created_at.beginning_of_week
    expect(timeline.grouped_items).to eq(
      { beginning_of_week => { completions: [completion], notes: [note] } }
    )
  end

  it 'returns items grouped with the most recent week first' do
    user = create(:user)
    timeline = Timeline.new(user)

    create(:completion, :previous_week, user: user, trail_object_id: 1, slug: 'foo')
    newest = create(:completion, :current_week, user: user, trail_object_id: 2, slug: 'foo')

    newest_week = newest.created_at.beginning_of_week
    expect(timeline.grouped_items.keys.first).to eq newest_week
  end

  it 'returns only the users completions and notes' do
    user = create(:user)
    another_user = create(:user)
    completion = create(:completion, user: user, slug: 'whatever')
    note = create(:note, user: user)
    timeline = Timeline.new(user)

    create(:completion, user: another_user, slug: 'whatever')
    create(:note, user: another_user)

    beginning_of_week = completion.created_at.beginning_of_week
    expect(timeline.grouped_items).to eq(
      { beginning_of_week => { completions: [completion], notes: [note] } }
    )
  end

  it 'returns items sorted DESC by creation_date' do
    user = create(:user)
    timeline = Timeline.new(user)

    oldest_item = create(:completion, created_at: 2.minute.ago, user: user, slug: 'foo', trail_object_id: '1')
    newest_item = create(:completion, created_at: Time.now, user: user, slug: 'foo', trail_object_id: '3')
    middle_item = create(:completion, created_at: 1.minutes.ago, user: user, slug: 'foo', trail_object_id: '2')

    beginning_of_week = oldest_item.created_at.beginning_of_week
    expect(timeline.grouped_items).to eq(
      { beginning_of_week =>  { completions: [newest_item, middle_item, oldest_item] } }
    )
  end

  it 'returns a null week with no items when there are no notes or completions' do
    user = create(:user)

    timeline = Timeline.new(user)

    expect(timeline.grouped_items).to eq({ Time.now.beginning_of_week => {} })
  end
end

describe Timeline, '#most_recent_week?' do
  it 'returns true when the passed in week is the most recent' do
    user = create(:user)
    timeline = Timeline.new(user)

    most_recent_item = create(:note, :current_week, user: user)
    completion_from_previous_week = create(:completion, :previous_week, user: user, slug: 'whatever2')

    most_recent_week  = most_recent_item.created_at.beginning_of_week
    expect(timeline.most_recent_week?(most_recent_week)).to be_true
  end

  it 'returns false when the passed in week is a past week' do
    user = create(:user)
    timeline = Timeline.new(user)

    most_recent_week = create(:note, :current_week, user: user)
    completion_from_previous_week = create(:completion, :previous_week, user: user, slug: 'whatever2')

    previous_week  = completion_from_previous_week.created_at.beginning_of_week
    expect(timeline.most_recent_week?(previous_week)).to be_false
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
