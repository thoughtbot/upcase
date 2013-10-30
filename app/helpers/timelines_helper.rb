module TimelinesHelper
  def week_title(week)
    "Week of #{week.strftime('%b %-d')} - #{week.end_of_week.strftime('%b %-d')}"
  end

  def edit_note_link(note)
    if allowed_to_be_edited?(note)
      link_to 'edit note', edit_user_note_path(@timeline.user, note)
    end
  end

  private

  def allowed_to_be_edited?(note)
    note.created_by?(current_user)
  end
end
