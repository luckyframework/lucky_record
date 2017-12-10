require "lucky_inflector"

module LuckyRecord::Join
  abstract class SqlClause
    getter :from_table, :to_table, :from_column, :to_column

    def initialize(@from_table : Symbol, @to_table : Symbol, @from_column : Symbol? = nil, @to_column : Symbol? = nil, @comparison : String? = "=", @using : Array(Symbol) = [] of Symbol)
    end

    abstract def join_type : String

    def to_sql
      if @using.any?
        "#{join_type} JOIN #{@to_table} USING (#{@using.join(',')})"
      else
        "#{join_type} JOIN #{@to_table} ON #{from_column} #{@comparison} #{to_column}"
      end
    end

    def from_column
      if @from_column
        "#{@from_table}.#{@from_column}"
      else
        "#{@from_table}.id"
      end
    end

    def to_column
      if @to_column
        "#{@to_table}.#{@to_column}"
      else
        foreign_key = LuckyInflector::Inflector.singularize(@from_table) + "_id"
        "#{@to_table}.#{foreign_key}"
      end
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
