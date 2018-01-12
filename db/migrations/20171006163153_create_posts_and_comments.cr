class CreatePostsAndComments::V20171006163153 < LuckyMigrator::Migration::V1
  def migrate
    create :posts do
      belongs_to Employee?, on_delete: :do_nothing
      add title : String
    end

    create :comments do
      add body : String
      belongs_to Post, on_delete: :cascade
    end
  end

  def rollback
    drop :posts
    drop :comments
  end
end
