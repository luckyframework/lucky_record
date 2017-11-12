abstract class LuckyRecord::Type
  def self.from_db(value)
    parse!(value)
  end

  def self.parse(value : Nil)
    SuccessfulCast(Nil).new(nil)
  end

  def self.parse(value : String)
    SuccessfulCast(String).new(value)
  end

  def self.parse!(value)
    parse(value).as(SuccessfulCast).value
  end

  def self.to_db(value : Nil)
    nil
  end

  def self.to_db(value : String)
    value
  end

  def self.to_db!(value)
    parsed_value = parse!(value)
    to_db(parsed_value)
  end

  class SuccessfulCast(T)
    getter :value

    def initialize(@value : T)
    end
  end

  class FailedCast
  end
end
