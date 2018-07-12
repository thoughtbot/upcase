class RemoveExternalRegistrationUrlFromWorkshops < ActiveRecord::Migration[4.2]
  def up
    remove_column :workshops, :external_registration_url
  end

  def down
    add_column :workshops, :external_registration_url, :string
  end
end
