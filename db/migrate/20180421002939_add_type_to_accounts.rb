class AddTypeToAccounts < ActiveRecord::Migration[5.2]
  def up
    add_column :accounts, :type, :string
    change_column_default :accounts, :type, 'Monstodon::Trainer'
  end

  def down
    remove_column :accounts, :type
  end
end
