namespace :completions do
  desc 'Add slug to completions'
  task :add_slug => :environment do
    puts 'Adding slug to completions'

    Completion.all.each do |completion|
      Trail.all.each do |trail|
        if completion_is_part_of_trail?(completion, trail)
          completion.update_attribute(:slug, trail.slug)
        end
      end
    end

    puts 'Slugs added to completions'
  end

  private

  def completion_is_part_of_trail?(completion, trail)
    trail.resources_and_validations.detect { |item| item['id'] == completion.trail_object_id }
  end
end
