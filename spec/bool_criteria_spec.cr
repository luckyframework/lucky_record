require "./spec_helper"

private class QueryMe < LuckyRecord::Model
  table users do
    field admin : Bool
  end
end

describe Bool::Lucky::Criteria do
  describe "is" do
    it "=" do
      admin.is(true).to_sql.should eq ["SELECT #{query_me_columns} FROM users WHERE admin = $1", "true"]
      admin.is(false).to_sql.should eq ["SELECT #{query_me_columns} FROM users WHERE admin = $1", "false"]
    end
  end
end

private def admin
  QueryMe::BaseQuery.new.admin
end

private def query_me_columns
  "users.id, users.created_at, users.updated_at, users.admin"
end
