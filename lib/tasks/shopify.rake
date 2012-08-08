namespace :shopify do
  desc 'Import the Shopify CSV'
  task import: :environment do
    if ENV['CSV'].blank?
      $stderr.puts "ERROR: Run as: rake shopify:import CSV=filename"
      exist 1
    end
    ShopifyImporter.run(ENV['CSV'])
  end
end
