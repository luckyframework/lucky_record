class CreateCompanies::V20180113081408 < LuckyMigrator::Migration::V1
  def migrate
    create :companies do
     add sales : Int64
    end
  end

  def rollback
    drop :companies
  end
end
