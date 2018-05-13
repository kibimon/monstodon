class BackfillAccountRoutingVersion < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    Account.in_batches.update_all routing_version: 1
    change_column_null :accounts, :routing_version, false
  end

  def down
    change_column_null :accounts, :routing_version, true
  end
end
