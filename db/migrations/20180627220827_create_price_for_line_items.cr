class CreatePriceForLineItems::V20180627220827 < LuckyMigrator::Migration::V1
  def migrate
    # Needs support in lucky_migrator
    # create :prices, primary_key_type: :uuid do
    #   add in_cents : Int32
    # end
    execute <<-SQL
      CREATE TABLE prices (
        id uuid PRIMARY KEY,
        in_cents integer NOT NULL,
        line_item_id uuid NOT NULL REFERENCES line_items (id),
        created_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone NOT NULL
      );
    SQL
  end

  def rollback
    drop :prices
  end
end
