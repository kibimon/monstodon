class AddAccountRoutingVersion < ActiveRecord::Migration[5.2]
  def up
    add_column :accounts, :routing_version, :integer
    change_column_default :accounts, :routing_version, 2
  end

  def down
    remove_column :accounts, :routing_version
  end
end
