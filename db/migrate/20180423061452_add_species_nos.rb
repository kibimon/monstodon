class AddSpeciesNos < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    # Creates our columns
    add_column :activitymon_species, :regional_no, :integer
    add_column :activitymon_species, :national_no, :integer

    # Indexes nonzero columns
    add_index :activitymon_species, :regional_no, where: "regional_no <> 0", unique: true, algorithm: :concurrently
    add_index :activitymon_species, :national_no, where: "national_no <> 0", unique: true, algorithm: :concurrently
    add_index :activitymon_species, :uri, name: "index_activitymon_species_on_uri", where: "uri IS NOT NULL", unique: false, algorithm: :concurrently

    # Creates sequences and uses them as the defaults for the columns
    safety_assured {
      execute <<-SQL
        CREATE SEQUENCE activitymon_species_regional_no_seq START 1;
        CREATE SEQUENCE activitymon_species_national_no_seq START 1;
        ALTER SEQUENCE activitymon_species_regional_no_seq OWNED BY activitymon_species.regional_no;
        ALTER SEQUENCE activitymon_species_national_no_seq OWNED BY activitymon_species.national_no;
        ALTER TABLE activitymon_species ALTER COLUMN regional_no SET DEFAULT nextval('activitymon_species_regional_no_seq');
        ALTER TABLE activitymon_species ALTER COLUMN national_no SET DEFAULT nextval('activitymon_species_national_no_seq');
      SQL
    }

    # Backfills columns
    ActivityMon::Species.where(uri: nil).in_batches.update_all(%q|regional_no = nextval('activitymon_species_regional_no_seq'), national_no = nextval('activitymon_species_national_no_seq')|)
    ActivityMon::Species.where.not(uri: nil).in_batches.update_all(%q|regional_no = 0, national_no = 0|)

    # Makes columns non-null
    change_column_null :activitymon_species, :regional_no, false
    change_column_null :activitymon_species, :national_no, false
  end

  def down
    # Removes indexs
    remove_index :activitymon_species, :regional_no
    remove_index :activitymon_species, :national_no
    remove_index :activitymon_species, name: :index_activitymon_species_on_uri

    # Removes columns
    remove_column :activitymon_species, :regional_no
    remove_column :activitymon_species, :national_no
  end
end
