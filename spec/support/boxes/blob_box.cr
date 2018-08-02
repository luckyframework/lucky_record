class BlobBox < BaseBox
  def initialize
    doc JSON::Any.new({"foo" => "bar"})
  end
end
