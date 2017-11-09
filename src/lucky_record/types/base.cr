abstract class LuckyRecord::Type
  # Used at compile time to map Crystal types to their LuckyRecord type
  CRYSTAL_TYPE_TO_LUCKY_RECORD_MAPPING = {} of Nil => Nil
  CRYSTAL_TYPE_TO_BASE_TYPE_MAPPING = {} of Nil => Nil

  macro base_type(type)
    {% CRYSTAL_TYPE_TO_LUCKY_RECORD_MAPPING[@type.class.name.stringify.gsub(/\:Class/, "")] = @type %}
    {% CRYSTAL_TYPE_TO_BASE_TYPE_MAPPING[@type.class.name.stringify.gsub(/\:Class/, "")] = type %}
  end

  def self.deserialize(value)
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

  def self.serialize(value : Nil)
    nil
  end

  def self.serialize(value : String)
    value
  end

  def self.parse_and_serialize(value)
    parseed_value = parse!(value)
    serialize(parseed_value)
  end

  class SuccessfulCast(T)
    getter :value

    def initialize(@value : T)
    end
  end

  class FailedCast
  end
end
