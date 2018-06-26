class CreateLineItem::V20180625202051 < LuckyMigrator::Migration::V1
  def migrate
    # Needs support in lucky_migrator
    # create :line_items, primary_key_type: :uuid do
    #   add name : String
    # end
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
