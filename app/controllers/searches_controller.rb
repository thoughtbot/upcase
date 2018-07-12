class SearchesController < ApplicationController
  before_action :require_login

  def show
    @topics = Topic.explorable
    @query = query
    @results = results
    track_search_query
  end

  def create
    redirect_to search_path(query: query)
  end

  private

  def track_search_query
    if query.present?
      analytics.track_searched(query: query, results_count: results.count)
    end
  end

  def results
    @_results ||= Search.new(@query).results
  end

  def query
    params[:query]
  end
end
