class AddSpeciesAndOwnerToAccount < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_reference :accounts, :owner, index: false
    add_reference :accounts, :species, index: false

    add_index :accounts, :owner_id, algorithm: :concurrently
    add_index :accounts, :species_id, algorithm: :concurrently
  end
end
