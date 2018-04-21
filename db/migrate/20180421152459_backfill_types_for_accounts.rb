class BackfillTypesForAccounts < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    Account.in_batches.update_all type: "ActivityMon::Trainer"
  end
end
