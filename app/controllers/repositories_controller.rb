class RepositoriesController < ApplicationController
  def index
    @catalog = Catalog.new
  end

  def show
    repository = Repository.friendly.find(params[:id])
    @offering = Offering.new(repository, current_user)

    if @offering.user_has_license?
      redirect_to repository.github_url
    else
      render template: "products/show"
    end
  end
end
