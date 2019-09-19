class TeamsController < ApplicationController
  before_action :must_be_team_owner, only: :edit
  before_action :redirect_from_teams_new, only: :new

  def new
    @landing_page = true
    @team_page = true
    @catalog = Catalog.new
  end

  def edit
    @team = current_team
  end

  private

  def redirect_from_teams_new
    redirect_to(
      root_path,
      alert: t("checkout.flashes.not_creating_new_teams"),
    )
  end
end
