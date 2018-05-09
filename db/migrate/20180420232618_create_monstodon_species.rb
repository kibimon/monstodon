class CreateMonstodonSpecies < ActiveRecord::Migration[5.2]
  def change
    create_table :monstodon_species do |t|
      t.string :name, null: false, default: ''
      t.string :uri

      t.timestamps
    end
  end
end
