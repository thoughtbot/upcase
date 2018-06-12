class TeamsController < ApplicationController
  before_action :must_be_team_owner, only: :edit

  def new
    @landing_page = true
    @team_page = true
    @catalog = Catalog.new
  end

  def edit
    @team = current_team
  end
end
