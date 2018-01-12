require "lucky_inflector"

module LuckyRecord::Join
  abstract class SqlClause
    getter :from, :to, :from_column, :to_column

    def initialize(@from : Symbol, @to : Symbol, @primary_key : Symbol? = nil, @foreign_key : Symbol? = nil, @comparison : String? = "=", @using : Array(Symbol) = [] of Symbol)
      @through = nil
    end

    def initialize(@from : Symbol, @to : Symbol, @through : Symbol)
      @using = [] of Symbol
    end

    abstract def join_type : String

    def to_sql
      if @through
        through_join_statement
      else
        direct_join_statement
      end
    end

    def through_join_statement
      "#{join_type} JOIN #{@through} ON #{@from}.id = #{@through}.#{from_foreign_key} \
      #{join_type} JOIN #{@to} ON #{@through}.id = #{@to}.#{through_foreign_key}"
    end

    def direct_join_statement
      if @using.any?
        using_options = @using.join(", ")
        "#{join_type} JOIN #{@to} USING (#{using_options})"
      else
        "#{join_type} JOIN #{@to} ON #{from_column} #{@comparison} #{to_column}"
      end
    end

    def from_column
      "#{@from}.#{@primary_key || "id"}"
    end

    def to_column
      "#{@to}.#{@foreign_key || from_foreign_key}"
    end

    def from_foreign_key
      LuckyInflector::Inflector.singularize(@from) + "_id"
    end

    def through_foreign_key
      LuckyInflector::Inflector.singularize(@through) + "_id"
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
