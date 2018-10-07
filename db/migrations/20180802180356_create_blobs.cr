class CreateBlobs::V20180802180356 < LuckyRecord::Migrator::Migration::V1
  def migrate
    create :blobs do
      add doc : JSON::Any?, default: { "defa'ult" => "val'ue" }
    end
  end

  def rollback
    drop :blobs
  end
end
