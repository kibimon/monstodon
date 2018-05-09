class BackfillASPropsOnSpeciesAndAccounts < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    Account.in_batches.update_all description: ''
    Monstodon::Species.in_batches.update_all summary: ''
    Monstodon::Species.in_batches.update_all content: ''

    change_column_default :accounts, :description, ''
    change_column_default :monstodon_species, :summary, ''
    change_column_default :monstodon_species, :content, ''

    change_column_null :accounts, :description, false
    change_column_null :monstodon_species, :summary, false
    change_column_null :monstodon_species, :content, false
  end

  def down
    change_column_null :accounts, :description, true
    change_column_null :monstodon_species, :summary, true
    change_column_null :monstodon_species, :content, true

    change_column_default :accounts, :description, nil
    change_column_default :monstodon_species, :summary, nil
    change_column_default :monstodon_species, :content, nil
  end
end
