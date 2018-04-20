class CreateActivityMonSpecies < ActiveRecord::Migration[5.2]
  def change
    create_table :activitymon_species do |t|
      t.string :name
      t.string :uri

      t.timestamps
    end
  end
end
