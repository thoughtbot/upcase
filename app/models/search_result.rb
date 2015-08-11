class SearchResult < SimpleDelegator
  attr_reader :excerpt

  def initialize(model, excerpt)
    @model = model
    @excerpt = excerpt
    super(@model)
  end

  def to_partial_path
    "searches/#{_model_name}"
  end

  def to_model
    self
  end

  private

  def _model_name
    @model.class.to_s.downcase
  end
end
