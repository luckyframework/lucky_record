require "./spec_helper.cr"

class BlobQuery < Blob::BaseQuery
end

class BlobForm < Blob::BaseForm
  allow :doc
end

describe "JSON Columns" do
  it "should work in boxes" do
    BlobBox.save
    blob = BlobQuery.new.first
    blob.doc.should eq JSON::Any.new({"foo" => "bar"})

    blob2 = BlobBox.new.doc(42).save
    blob2.doc.should eq JSON::Any.new(42)
  end
  it "should convert scalars and save forms" do
    form1 = BlobForm.new({"doc" => 42})
    form1.doc.value.should eq JSON::Any.new(42)

    form2 = BlobForm.new({"doc" => "hey"})
    form2.doc.value.should eq JSON::Any.new("hey")
  end
  it "should convert hashes and arrays and save forms" do
    form1 = BlobForm.new({"doc" => [1, 2, 3]})
    form1.doc.value.should eq JSON::Any.new([1, 2, 3])

    form2 = BlobForm.new({"doc" => {"foo" => "baz"}})
    form2.doc.value.should eq JSON::Any.new({"foo" => "baz"})
  end
end
