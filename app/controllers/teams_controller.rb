class TeamsController < ApplicationController
  before_filter :must_be_team_owner

  def edit
    @team = current_team
  end
end
