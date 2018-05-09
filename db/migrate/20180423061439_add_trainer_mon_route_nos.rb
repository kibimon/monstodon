class AddTrainerMonRouteNos < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    # Creates our columns
    add_column :accounts, :mon_no, :integer
    add_column :accounts, :route_no, :integer
    add_column :accounts, :trainer_no, :integer

    # Indexes nonzero columns
    add_index :accounts, :mon_no, where: "mon_no <> 0", unique: true, algorithm: :concurrently
    add_index :accounts, :route_no, where: "route_no <> 0", unique: true, algorithm: :concurrently
    add_index :accounts, :trainer_no, where: "trainer_no <> 0", unique: true, algorithm: :concurrently

    # Creates sequences and uses them as the defaults for the columns
    safety_assured {
      execute <<-SQL
        CREATE SEQUENCE accounts_mon_no_seq START 1;
        CREATE SEQUENCE accounts_route_no_seq START 1;
        CREATE SEQUENCE accounts_trainer_no_seq START 1;
        ALTER SEQUENCE accounts_mon_no_seq OWNED BY accounts.mon_no;
        ALTER SEQUENCE accounts_route_no_seq OWNED BY accounts.route_no;
        ALTER SEQUENCE accounts_trainer_no_seq OWNED BY accounts.trainer_no;
        ALTER TABLE accounts ALTER COLUMN mon_no SET DEFAULT nextval('accounts_mon_no_seq');
        ALTER TABLE accounts ALTER COLUMN route_no SET DEFAULT nextval('accounts_route_no_seq');
        ALTER TABLE accounts ALTER COLUMN trainer_no SET DEFAULT nextval('accounts_trainer_no_seq');
      SQL
    }

    # Backfills columns
    Account.where(type: 'ActivityMon::Mon', domain: nil).in_batches.update_all(%q|mon_no = nextval('accounts_mon_no_seq'), route_no = 0, trainer_no = 0|)
    Account.where(type: 'ActivityMon::Route', domain: nil).in_batches.update_all(%q|route_no = nextval('accounts_route_no_seq')|)
    Account.where(type: 'ActivityMon::Trainer', domain: nil).in_batches.update_all(%q|mon_no = 0, route_no = 0, trainer_no = nextval('accounts_trainer_no_seq')|)
    Account.where.not(type: %w(ActivityMon::Mon ActivityMon::Route ActivityMon::Trainer), domain: nil).in_batches.update_all(%q|mon_no = 0, route_regional_no = 0, route_national_no = 0, trainer_no = 0|)

    # Makes columns non-null
    change_column_null :accounts, :mon_no, false
    change_column_null :accounts, :route_no, false
    change_column_null :accounts, :trainer_no, false
  end

  def down
    # Removes indexes
    remove_index :accounts, :mon_no
    remove_index :accounts, :route_no
    remove_index :accounts, :trainer_no

    # Removes columns
    remove_column :accounts, :mon_no
    remove_column :accounts, :route_no
    remove_column :accounts, :trainer_no
  end
end
