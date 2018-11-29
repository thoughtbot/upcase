def find_user(email)
  User.find_by(email: email)
end
