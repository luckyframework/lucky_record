class CompanyBox < BaseBox
  def initialize
    sales (Int32::MAX + 1000).to_i64
    earnings 1.0
  end
end
