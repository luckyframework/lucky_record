module LuckyRecord::Where
  abstract class SqlClause
    getter :column, :value

    def initialize(@column : Symbol | String, @value : String)
    end

    abstract def operator : String

    def prepare(prepared_statement_placeholder : String)
      "#{column} #{operator} #{prepared_statement_placeholder}"
    end
  end

  class Equal < SqlClause
    def operator
      "="
    end

    def negated : SqlClause
      NotEqual.new(@column, @value)
    end
  end

  class NotEqual < SqlClause
    def operator
      "!="
    end

    def negated : SqlClause
      Equal.new(@column, @value)
    end
  end

  class GreaterThan < SqlClause
    def operator
      ">"
    end

    def negated : SqlClause
      LessThanOrEqualTo.new(@column, @value)
    end
  end

  class GreaterThanOrEqualTo < SqlClause
    def operator
      ">="
    end

    def negated : SqlClause
      LessThan.new(@column, @value)
    end
  end

  class LessThan < SqlClause
    def operator
      "<"
    end

    def negated : SqlClause
      GreaterThanOrEqualTo.new(@column, @value)
    end
  end

  class LessThanOrEqualTo < SqlClause
    def operator
      "<="
    end

    def negated : SqlClause
      GreaterThan.new(@column, @value)
    end
  end

  class Like < SqlClause
    def operator
      "LIKE"
    end

    def negated : SqlClause
      NotLike.new(@column, @value)
    end
  end

  class Ilike < SqlClause
    def operator
      "ILIKE"
    end

    def negated : SqlClause
      NotIlike.new(@column, @value)
    end
  end

  class NotLike < SqlClause
    def operator
      "NOT LIKE"
    end

    def negated : SqlClause
      Like.new(@column, @value)
    end
  end

  class NotIlike < SqlClause
    def operator
      "NOT ILIKE"
    end

    def negated : SqlClause
      Ilike.new(@column, @value)
    end
  end
end
