require "./string"

class LuckyRecord::EmailType < LuckyRecord::StringType
  def self.parse(value : String)
    SuccessfulCast(String).new(value.downcase.strip)
  end
end
