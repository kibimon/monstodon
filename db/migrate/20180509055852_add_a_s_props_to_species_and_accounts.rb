class AddASPropsToSpeciesAndAccounts < ActiveRecord::Migration[5.2]
  def up
    add_column :accounts, :description, :string
    add_column :monstodon_species, :summary, :string
    add_column :monstodon_species, :content, :string
  end

  def down
    remove_column :accounts, :description
    remove_column :monstodon_species, :summary
    remove_column :monstodon_species, :content
  end
end
