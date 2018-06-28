class CreateProduct::V20180628193054 < LuckyMigrator::Migration::V1
  def migrate
    # create :products, primary_key_type: :uuid do
    #  add line_item_id : UUID
    # end
    execute <<-SQL
      CREATE TABLE products (
        id uuid PRIMARY KEY,
        created_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone NOT NULL
      );
    SQL
  end

  def rollback
    drop :products
  end
end
