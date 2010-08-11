module AuthenticationLinksHelper
  def authentication_links
    if signed_in?
      if current_user.teacher?
        signed_in_teacher_links
      else
        signed_in_student_links
      end
    else
      signed_out_links
    end
  end

  def signed_out_links
    [link_to("Sign in", sign_in_path)]
  end

  def signed_in_student_links
    [].tap do |links|
      if current_user.change_password?
        links << link_to("Change password", edit_my_password_path)
      end
      links << link_to("Sign out", sign_out_path)
    end
  end

  def signed_in_teacher_links
    [link_to("Admin",    admin_home_path),
     link_to("Sign out", sign_out_path)]
  end
end
