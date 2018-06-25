struct UUID
  module Lucky
    alias ColumnType = UUID
    include LuckyRecord::Type

    def parse(value : UUID)
      SuccessfulCast(UUID).new(value)
    end

    # form form #set_id_from_param
    def parse(value : String)
      SuccessfulCast(UUID).new(UUID.new(value))
    end

    def to_db(value : UUID)
      value.to_s
    end

    # class Criteria(T, V) < LuckyRecord::Criteria(T, V)
    #   @upper = false
    #   @lower = false

    #   def like(value : String) : T
    #     add_clause(LuckyRecord::Where::Like.new(column, value))
    #   end

    #   def ilike(value : String) : T
    #     add_clause(LuckyRecord::Where::Ilike.new(column, value))
    #   end

    #   def upper
    #     @upper = true
    #     self
    #   end

    #   def lower
    #     @lower = true
    #     self
    #   end

    #   def column
    #     if @upper
    #       "UPPER(#{@column})"
    #     elsif @lower
    #       "LOWER(#{@column})"
    #     else
    #       @column
    #     end
    #   end
    # end
  end
end
