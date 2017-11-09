require "./string"

class LuckyRecord::EmailType < LuckyRecord::StringType
  base_type String

  def self.parse(value : String)
    SuccessfulCast(String).new(value.downcase.strip)
  end
end
