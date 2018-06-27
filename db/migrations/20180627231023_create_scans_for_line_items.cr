class CreateScansForLineItems::V20180627231023 < LuckyMigrator::Migration::V1
  def migrate
    # create :scans do
    #  add scanned_at : Time
    #  add line_item_id : UUID
    # end
    execute <<-SQL
      CREATE TABLE scans (
        id serial PRIMARY KEY,
        scanned_at timestamp with time zone NOT NULL,
        line_item_id uuid NOT NULL REFERENCES line_items (id),
        created_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone NOT NULL
      );
    SQL
  end

  def rollback
    drop :scans
  end
end
