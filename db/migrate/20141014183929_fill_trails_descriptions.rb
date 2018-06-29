class FillTrailsDescriptions < ActiveRecord::Migration[4.2]
  def change
    update("UPDATE trails SET description = 'A method of improving code quality and minimizing time required to add new features to software by ensuring that each facet of the program works as expected.'")
  end
end
