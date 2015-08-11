class SearchesController < ApplicationController
  def show
    @query = get_query
    @results = results_with_excerpts
  end

  def create
    redirect_to search_path(query: get_query)
  end

  private

  def results_with_excerpts
    Search.new(@query).results
  end

  def get_query
    params[:query]
  end
end
