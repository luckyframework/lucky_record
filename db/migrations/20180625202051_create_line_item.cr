class CreateLineItem::V20180625202051 < LuckyMigrator::Migration::V1
  def migrate
    execute <<-SQL
      CREATE TABLE line_items (
        id uuid PRIMARY KEY,
        name text NOT NULL,
        created_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone NOT NULL
      );
    SQL
  end

  def rollback
    drop :line_items
  end
end
