module TimelinesHelper
  def week_title(week)
    "Week of #{week.strftime('%b %-d')} - #{week.end_of_week.strftime('%b %-d')}"
  end

  def edit_note_link(note)
    if note.allowed_to_be_edited_by?(current_user)
      link_to 'edit note', edit_note_path(note, timeline_user_id: @timeline.user_id)
    end
  end
end
