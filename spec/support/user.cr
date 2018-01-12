require "./sign_in_credential"

class User < LuckyRecord::Model
  COLUMNS = "users.id, users.created_at, users.updated_at, users.name, users.age, users.nickname, users.joined_at"

  table users do
    column name : String
    column age : Int32
    column nickname : String?
    column joined_at : Time
    has_one sign_in_credential : SignInCredential?
    has_many posts : Post
    has_many comments : Comment, through: :posts
  end
end

class UserQuery < User::BaseQuery
end
