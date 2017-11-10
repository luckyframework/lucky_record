module LuckyRecord
  # = Lucky Record Errors
  #
  # Generic Lucky Record exception class.
  class LuckyRecordError < Exception
  end

  # Raised when Lucky Record cannot find a record by given id
  class RecordNotFoundError < LuckyRecordError
    def initialize(@model : Symbol, @id : String)
      super "Could not find #{model} with id of #{id}"
    end
  end

  # Raised when using the save! or update! methods on a form when it does not have the proper attributes
  class InvalidFormError < LuckyRecordError
  end
end
