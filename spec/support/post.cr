require "./employee"
require "./comment"

class Post < LuckyRecord::Model
  table posts do
    column title : String
    column published_at : Time?
    belongs_to employee : Employee
    has_many comments : Comment
  end
end
