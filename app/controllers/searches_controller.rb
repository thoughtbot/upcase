class SearchesController < ApplicationController
  def show
    @topics = Topic.explorable
    @query = query
    @results = results
  end

  def create
    redirect_to search_path(query: query)
  end

  private

  def results
    @_results ||= Search.new(@query).results
  end

  def query
    params[:query]
  end
end
