require "lucky_inflector"

module LuckyRecord::Join
  abstract class SqlClause
    getter :from_table, :to_table, :from_column, :to_column

    def initialize(@from : Symbol, @to : Symbol, @primary_key : Symbol? = nil, @foreign_key : Symbol? = nil, @comparison : String? = "=", @using : Array(Symbol) = [] of Symbol)
    end

    abstract def join_type : String

    def to_sql
      if @using.any?
        %(#{join_type} JOIN #{to_table} USING (#{@using.join(", ")}))
      else
        "#{join_type} JOIN #{to_table} ON #{from_column} #{@comparison} #{to_column}"
      end
    end

    def from_table
      LuckyInflector::Inflector.pluralize(@from)
    end

    def to_table
      LuckyInflector::Inflector.pluralize(@to)
    end

    def from_column
      "#{from_table}.#{@primary_key || "id"}"
    end

    def to_column
      "#{to_table}.#{@foreign_key || default_foreign_key}"
    end

    def default_foreign_key
      LuckyInflector::Inflector.singularize(@from) + "_id"
    end
  end

  class Inner < SqlClause
    def join_type
      "INNER"
    end
  end

  class Left < SqlClause
    def join_type
      "LEFT"
    end
  end

  class Right < SqlClause
    def join_type
      "RIGHT"
    end
  end

  class Full < SqlClause
    def join_type
      "FULL"
    end
  end
end
