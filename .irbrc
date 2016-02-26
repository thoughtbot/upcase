def find_user(email)
  User.find_by_email(email)
end
