module SearchHelpers
  def populate_search_index
    [Video, Flashcard, Trail].each do |model|
      PgSearch::Multisearch.rebuild(model)
    end
  end
end

RSpec.configure { |config| config.include SearchHelpers }
