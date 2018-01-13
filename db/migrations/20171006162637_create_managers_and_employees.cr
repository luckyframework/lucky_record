class CreateManagersAndEmployees::V20171006162637 < LuckyMigrator::Migration::V1
  def migrate
    create :managers do
      add name : String
    end

    create :employees do
      add name : String
      add manager_id : Int32?
    end
  end

  def rollback
    drop :employees
    drop :managers
  end
end
