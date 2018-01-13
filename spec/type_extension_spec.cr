require "./spec_helper.cr"

class CompanyQuery < Company::BaseQuery
end

class CompanyForm < Company::BaseForm
  allow :sales

  def prepare
    validate_required sales
  end
end

describe "TypeExtensions" do
  it "should work in boxes" do
    CompanyBox.save
    company = CompanyQuery.new.first
    company.sales.should eq Int32::MAX + 1000

    company2 = CompanyBox.new.sales(10_i64).save
    company2.sales.should eq 10_i64
  end

  it "should build and save forms" do
    form = CompanyForm.new({"sales" => "10"})
    form.sales.value.should eq 10_i64
    company = form.save!
    company.sales.should eq 10_i64
  end

  it "should query" do
    CompanyBox.new.sales(10_i64).save
    company = CompanyQuery.new.sales(10).first
    company.sales.should eq 10_i64
  end
end