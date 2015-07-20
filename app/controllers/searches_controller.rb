class SearchesController < ApplicationController
  def show
    @query = get_query
    @results = results_with_highlights
  end

  def create
    redirect_to search_path(query: get_query)
  end

  private

  def get_query
    params[:query]
  end

  def search_results
    @_search_results ||= PgSearch.multisearch(@query)
  end

  def results_with_highlights
    results = search_results
    delimiter = "<br>"
    highlights = search_results.select(<<-HEADLINE_QUERY.strip_heredoc
      ts_headline(
        pg_search_documents.content,
        plainto_tsquery('#{@query}'),
        'MaxFragments=2,
        MinWords=5,
        MaxWords=15,
        FragmentDelimiter=\" ...#{delimiter} \",
        StartSel=\"<span class=highlight>\",
        StopSel=\"</span>\"'
      ) AS excerpt
      HEADLINE_QUERY
    )
    results.zip(highlights.map(&:excerpt))
  end
end
