struct JSON::Any
  module Lucky
    alias ColumnType = JSON::Any
    include LuckyRecord::Type

    alias JSONType = Array(JSONType) | Bool | Float64 | Hash(String, JSONType) | Int64 | String | Nil | Int32 | Float32

    def self.from_db!(value : JSON::Any)
      value
    end

    def self.parse(value : JSON::Any)
      SuccessfulCast(JSON::Any).new value
    end

    def self.parse(value : JSONType)
      SuccessfulCast(JSON::Any).new JSON.parse(value.to_json)
    end

    def self.to_db(value : JSONType)
      value.to_json
    end

    class Criteria(T, V) < LuckyRecord::Criteria(T, V)
    end
  end
end
