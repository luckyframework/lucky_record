require "./comment"

class Post < LuckyRecord::Model
  table posts do
    column title : String
    column published_at : Time?
    belongs_to user : User
    has_many comments : Comment
  end
end
