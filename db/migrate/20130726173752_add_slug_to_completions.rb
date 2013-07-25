class AddSlugToCompletions < ActiveRecord::Migration
  def up
    add_column :completions, :slug, :string

    Completion.reset_column_information

    Completion.all.each do |completion|
      Trail.all.each do |trail|
        if completion_is_part_of_trail?(completion, trail)
          completion.update_attribute(:slug, trail.slug)
        end
      end
    end
  end

  def down
    remove_column :completions, :slug
  end

  private

  def completion_is_part_of_trail?(completion, trail)
    trail.resources_and_validations.detect { |item| item['id'] == completion.trail_object_id }
  end
end
