class BackfillTypesForAccountsAgain < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  
  def change
    Account.mon_index.in_batches.update_all(type: 'ActivityMon::Mon')
    Account.trainers.in_batches.update_all(type: 'ActivityMon::Trainer')
    Account.routes.in_batches.update_all(type: 'ActivityMon::Route')
  end
end
