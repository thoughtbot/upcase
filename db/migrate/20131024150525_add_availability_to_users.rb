class AddAvailabilityToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column(
      :users,
      :availability,
      :string,
      null: false,
      default: "11am to 5pm on Fridays"
    )
  end
end
