require "./spec_helper"

private class QueryMe < LuckyRecord::Model
  COLUMNS = "users.id, users.created_at, users.updated_at, users.email, users.age"

  table users do
    field email : CustomEmail
    field age : Int32
  end
end

# USERS
# id serial PRIMARY KEY,
# name text NOT NULL,
# created_at timestamp NOT NULL,
# updated_at timestamp NOT NULL,
# age int NOT NULL,
# nickname text,
# joined_at timestamp NOT NULL
private class IncorrectFieldMappings < LuckyRecord::Model
  COLUMNS = "users.id, users.created_at, users.updated_at, users.name, users.age, users.nickname"

  table users do
    field name : String
    field age : Int32
    field nickname : String
  end
end

private class MissingTable < LuckyRecord::Model
  table uusers do
  end
end

private class EmptyModelCompilesOk < LuckyRecord::Model
  table no_fields do
  end
end

describe LuckyRecord::Model do
  it "sets up initializers based on the fields" do
    now = Time.now

    user = User.new id: 123,
      name: "Name",
      age: 24,
      joined_at: now,
      created_at: now,
      updated_at: now,
      nickname: "nick"

    user.name.should eq "Name"
    user.age.should eq 24
    user.joined_at.should eq now
    user.updated_at.should eq now
    user.created_at.should eq now
    user.nickname.should eq "nick"
  end

  it "can be used for params" do
    now = Time.now

    user = User.new id: 123,
      name: "Name",
      age: 24,
      joined_at: now,
      created_at: now,
      updated_at: now,
      nickname: "nick"

    user.to_param.should eq "123"
  end

  it "sets up getters that parse the values" do
    user = QueryMe.new id: 123,
      created_at: Time.now,
      updated_at: Time.now,
      age: 30,
      email: " Foo@bar.com "

    user.email.should be_a(CustomEmail)
    user.email.to_s.should eq "foo@bar.com"
  end

  it "sets up simple methods for equality" do
    query = QueryMe::BaseQuery.new.email("foo@bar.com").age(30)

    query.to_sql.should eq ["SELECT #{QueryMe::COLUMNS} FROM users WHERE email = $1 AND age = $2", "foo@bar.com", "30"]
  end

  it "sets up advanced criteria methods" do
    query = QueryMe::BaseQuery.new.email.upper.is("foo@bar.com").age.gt(30)

    query.to_sql.should eq ["SELECT #{QueryMe::COLUMNS} FROM users WHERE UPPER(email) = $1 AND age > $2", "foo@bar.com", "30"]
  end

  it "parses values" do
    query = QueryMe::BaseQuery.new.email.upper.is(" Foo@bar.com").age.gt(30)

    query.to_sql.should eq ["SELECT #{QueryMe::COLUMNS} FROM users WHERE UPPER(email) = $1 AND age > $2", "foo@bar.com", "30"]
  end

  it "lets you order by columns" do
    query = QueryMe::BaseQuery.new.age.asc_order.email.desc_order

    query.to_sql.should eq ["SELECT #{QueryMe::COLUMNS} FROM users ORDER BY users.age ASC, users.email DESC"]
  end

  it "can be deleted" do
    create_user
    user = UserQuery.new.first

    user.delete

    User::BaseQuery.all.size.should eq 0
  end

  describe ".column_names" do
    it "returns list of mapped fields" do
      QueryMe.column_names.should eq [:id, :created_at, :updated_at, :email, :age]
    end
  end

  describe ".ensure_correct_field_mappings" do
    # table is missing
    it "raises on missing table" do
      missing_table = MissingTable.new(1, Time.new, Time.new)
      expect_raises Exception, "The table uusers was not found, did you mean users?" do
        missing_table.ensure_correct_field_mappings!
      end
    end
    # field defined in model without a matching column in table
    # field is optional but column on table is marked as NOT NULL
    # field is required but the column does not have NOT NULL
  end
end
