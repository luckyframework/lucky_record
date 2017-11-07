# = Lucky Record Errors
#
# Generic Lucky Record exception class.
class LuckyRecordError < Exception
end

# Raised when Lucky Record cannot find a record by given id
class RecordNotFound < LuckyRecordError
  getter model : (String|Nil)
  getter primary_key : (String|Nil)
  getter id : (String|Int32|Nil)

  def initialize(message : (String|Nil) = nil, model : (String|Nil) = nil, primary_key : (String|Nil) = nil, id : (String|Int32|Nil) = nil)
    @primary_key = primary_key
    @model = model
    @id = id

    super(message)
  end
end
