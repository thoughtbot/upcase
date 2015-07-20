namespace :search do
  desc "Rebuild search index for all searchables"
  task rebuild: :environment do
    SEARCHABLE_MODELS = [Video, Flashcard, Trail]

    puts "Clearing existing search index entries..."
    PgSearch::Document.delete_all

    puts "Rebuilding index for #{SEARCHABLE_MODELS.join(', ')}."
    SEARCHABLE_MODELS.each do |model|
      PgSearch::Multisearch.rebuild(model)
    end
  end
end
