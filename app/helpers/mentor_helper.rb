module MentorHelper
  def mentor_image(mentor)
    image_tag gravatar_url(mentor.email, size: '300')
  end

  def mentor_contact_link(mentor)
    mail_to(
      mentor.email,
      I18n.t(
        'dashboards.show.contact_your_mentor',
        mentor_name: mentor.first_name
      )
    )
  end
end
