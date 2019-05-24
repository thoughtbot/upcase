class RepositoriesController < ApplicationController
  def index
    @catalog = Catalog.new
  end

  def show
    @repository = Repository.friendly.find(params[:id])

    redirect_to @repository.github_url
  end
end
