class AddTypeToAccountsAgain < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :type, :string
    change_column_default :accounts, :type, from: nil, to: 'ActivityMon::Trainer'
  end
end
