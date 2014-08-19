def add_user_to_team(user, team)
  user.team = team
  user.save!
end
