class LuckyRecord::TimeType < LuckyRecord::Type
  base_type String

  def self.parse(value : String)
    SuccessfulCast(Time).new Time.parse(value, pattern: "%FT%X%z")
  rescue Time::Format::Error
    FailedCast.new
  end

  def self.parse(value : Time)
    SuccessfulCast(Time).new value
  end

  def self.serialize(value : Time)
    value.to_s
  end
end
