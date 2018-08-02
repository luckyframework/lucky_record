class CreateBlobs::V20180802180356 < LuckyMigrator::Migration::V1
  def migrate
    create :blobs do
    end
    execute "alter table blobs add column doc jsonb;"
  end

  def rollback
    drop :blobs
  end
end
