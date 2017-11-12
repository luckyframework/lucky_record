class LuckyRecord::TimeType < LuckyRecord::Type
  alias BaseType = Time

  def self.parse(value : String)
    SuccessfulCast(Time).new Time.parse(value, pattern: "%FT%X%z")
  rescue Time::Format::Error
    FailedCast.new
  end

  def self.parse(value : Time)
    SuccessfulCast(Time).new value
  end

  def self.to_db(value : Time)
    value.to_s
  end
end
