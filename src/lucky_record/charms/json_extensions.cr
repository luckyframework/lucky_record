struct JSON::Any
  module Lucky
    alias ColumnType = JSON::Any
    include LuckyRecord::Type

    def self.from_db!(value : JSON::Any)
      value
    end

    def self.parse(value : JSON::Any)
      SuccessfulCast(JSON::Any).new value
    end

    def self.parse(value : JSON::Type)
      SuccessfulCast(JSON::Any).new JSON::Any.new(value)
    end

    def self.parse(value : String)
      SuccessfulCast(JSON::Any).new JSON.parse(value)
    rescue
      FailedCast.new
    end

    def self.to_db(value : Float64)
      value.to_json
    end

    class Criteria(T, V) < LuckyRecord::Criteria(T, V)
    end
  end
end
