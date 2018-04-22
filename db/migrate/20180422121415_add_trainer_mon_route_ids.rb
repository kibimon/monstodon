class AddTrainerMonRouteIds < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    # Creates our columns
    add_column :accounts, :mon_id, :integer
    add_column :accounts, :route_no, :integer
    add_column :accounts, :trainer_id, :integer

    # Indexes nonzero columns
    add_index :accounts, :mon_id, where: "mon_id != 0", unique: true, algorithm: :concurrently
    add_index :accounts, :route_no, where: "route_no != 0", unique: true, algorithm: :concurrently
    add_index :accounts, :trainer_id, where: "trainer_id != 0", unique: true, algorithm: :concurrently

    # Creates sequences and uses them as the defaults for the columns
    safety_assured {
      execute <<-SQL
        CREATE SEQUENCE accounts_mon_id_seq START 1;
        CREATE SEQUENCE accounts_route_no_seq START 1;
        CREATE SEQUENCE accounts_trainer_id_seq START 1;
        ALTER SEQUENCE accounts_mon_id_seq OWNED BY accounts.mon_id;
        ALTER SEQUENCE accounts_route_no_seq OWNED BY accounts.route_no;
        ALTER SEQUENCE accounts_trainer_id_seq OWNED BY accounts.trainer_id;
        ALTER TABLE accounts ALTER COLUMN mon_id SET DEFAULT nextval('accounts_mon_id_seq');
        ALTER TABLE accounts ALTER COLUMN route_no SET DEFAULT nextval('accounts_route_no_seq');
        ALTER TABLE accounts ALTER COLUMN trainer_id SET DEFAULT nextval('accounts_trainer_id_seq');
      SQL
    }

    # Backfills columns
    Account.where({ type: 'ActivityMon::Mon' }).in_batches.update_all(%q|mon_id = nextval('accounts_mon_id_seq'), route_no = 0, trainer_id = 0|)
    Account.where({ type: 'ActivityMon::Route' }).in_batches.update_all(%q|mon_id = 0, route_no = nextval('accounts_route_no_seq'), trainer_id = 0|)
    Account.where({ type: 'ActivityMon::Trainer' }).in_batches.update_all(%q|mon_id = 0, route_no = 0, trainer_id = nextval('accounts_trainer_no_seq')|)
    Account.where.not({ type: ['ActivityMon::Mon', 'ActivityMon::Route', 'ActivityMon::Trainer'] }).in_batches.update_all(%q|mon_id = 0, route_no = 0, trainer_id = 0|)

    # Makes columns non-null
    change_column_null :accounts, :mon_id, false
    change_column_null :accounts, :route_no, false
    change_column_null :accounts, :trainer_id, false

    # Removes unnecessary type column
    safety_assured {
      remove_column :accounts, :type
    }
  end

  def down
    # Adds type column
    add_column :accounts, :type
    Account.where.not({ mon_id: 0 }).in_batches.update_all type: "ActivityMon::Mon"
    Account.where.not({ route_no: 0 }).in_batches.update_all type: "ActivityMon::Route"
    Account.where.not({ trainer_id: 0 }).in_batches.update_all type: "ActivityMon::Trainer"

    # Removes columns
    remove_column :accounts, :mon_id
    remove_column :accounts, :route_no
    remove_column :accounts, :trainer_id
  end
end
