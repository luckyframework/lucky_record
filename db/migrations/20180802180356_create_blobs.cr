class CreateBlobs::V20180802180356 < LuckyMigrator::Migration::V1
  def migrate
    create :blobs do
      add doc : JSON::Any?
    end
  end

  def rollback
    drop :blobs
  end
end
