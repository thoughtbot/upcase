module Teams
  class TeamsController < ApplicationController
    before_filter :must_be_team_member

    def edit
      @team = current_user.team
    end
  end
end
