class CreateAdmins::V20170127143150 < LuckyRecord::Migrator::Migration::V1
  def migrate
    create :admins do
      add name : String
    end
  end

  def rollback
    drop :admins
  end
end
