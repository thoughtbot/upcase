class RepositoriesController < ApplicationController
  def index
    @catalog = Catalog.new
  end

  def show
    @repository = Repository.friendly.find(params[:id])

    check_collaboration do
      check_github_access do
        redirect_to @repository.github_url
      end
    end
  end

  private

  def check_collaboration
    if @repository.has_collaborator?(current_user)
      yield
    else
      render_html :show
    end
  end

  def check_github_access
    if @repository.has_github_collaborator?(current_user)
      yield
    else
      render_html :status
    end
  end

  def render_html(template_name)
    respond_to do |format|
      format.html { render template_name }
    end
  end
end
