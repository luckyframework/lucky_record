class LuckyRecord::Field(T)
  getter :name
  getter :value
  getter :form_name
  @errors = [] of String
  @changed = false

  def initialize(@name : Symbol, @param : String?, @value : T, @form_name : String)
  end

  def param
    @param || value.to_s
  end

  def add_error(message : Object = "is invalid")
    message = message.call(@name.to_s, @value.to_s) if message.responds_to?(:call)
    @errors << message
  end

  def errors
    @errors.uniq
  end

  def valid?
    errors.empty?
  end

  def value=(@value)
    @changed = true
  end

  def changed?
    @changed
  end
end
