class UpdatePolymorphicReferences < ActiveRecord::Migration[4.2]
  def up
    say_with_time "Converting Screencasts into VideoTutorials (products.type)" do
      update "UPDATE products SET type='VideoTutorial' WHERE type='Screencast'"
    end
  end

  def down
  end
end
