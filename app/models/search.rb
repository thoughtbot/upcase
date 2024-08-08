class Search
  def initialize(query)
    @raw_query = query
  end

  def results
    model_and_excerpt_pairs.map do |model, excerpt|
      SearchResult.new(model, excerpt)
    end
  end

  private

  def model_and_excerpt_pairs
    matching_models.zip(excerpts)
  end

  def matching_models
    search_results.map(&:searchable)
  end

  def excerpts
    search_results.select(excerpt_query).map(&:excerpt)
  end

  def search_results
    @_search_results ||= PgSearch.multisearch(@raw_query)
  end

  def sanitized_query
    ActiveRecord::Base.connection.quote(@raw_query)
  end

  def excerpt_query
    <<-EXCERPT_QUERY.strip_heredoc
      ts_headline(
        pg_search_documents.content,
        plainto_tsquery(#{sanitized_query}),
        'MaxFragments=2,
        MinWords=5,
        MaxWords=15,
        FragmentDelimiter="...<br/>",
        StartSel="<span class=highlight>",
        StopSel="</span>"'
      ) AS excerpt
    EXCERPT_QUERY
  end
end
