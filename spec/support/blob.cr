class Blob < LuckyRecord::Model
  table blobs do
    column doc : JSON::Any?
  end
end
