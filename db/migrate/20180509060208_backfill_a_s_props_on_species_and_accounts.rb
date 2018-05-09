class BackfillASPropsOnSpeciesAndAccounts < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    Account.in_batches.update_all description: ''
    ActivityMon::Species.where(name: nil).in_batches.update_all name: ''
    ActivityMon::Species.in_batches.update_all summary: ''
    ActivityMon::Species.in_batches.update_all content: ''

    change_column_default :accounts, :description, ''
    change_column_default :activitymon_species, :name, ''
    change_column_default :activitymon_species, :summary, ''
    change_column_default :activitymon_species, :content, ''

    change_column_null :accounts, :description, false
    change_column_null :activitymon_species, :name, false
    change_column_null :activitymon_species, :summary, false
    change_column_null :activitymon_species, :content, false
  end

  def down
    change_column_null :accounts, :description, true
    change_column_null :activitymon_species, :name, true
    change_column_null :activitymon_species, :summary, true
    change_column_null :activitymon_species, :content, true

    change_column_default :accounts, :description, nil
    change_column_default :activitymon_species, :name, nil
    change_column_default :activitymon_species, :summary, nil
    change_column_default :activitymon_species, :content, nil
  end
end
