require "./manager"

class Employee < LuckyRecord::Model
  table employees do
    column name : String
    belongs_to manager : Manager?
    has_many posts : Post
    has_many comments : Comment, through: :posts
  end
end
