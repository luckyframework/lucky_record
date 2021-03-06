class LuckyRecord::Criteria(T, V)
  property :rows, :column
  @negate_next_criteria : Bool

  def initialize(@rows : T, @column : Symbol | String)
    @negate_next_criteria = false
  end

  def desc_order
    rows.query.order_by(column, :desc)
    rows
  end

  def asc_order
    rows.query.order_by(column, :asc)
    rows
  end

  def is(value)
    add_clause(LuckyRecord::Where::Equal.new(column, V::Lucky.to_db!(value)))
    rows
  end

  def not(value) : T
    is_not(value)
  end

  def not : LuckyRecord::Criteria
    @negate_next_criteria = true
    self
  end

  def is_not(value) : T
    add_clause(LuckyRecord::Where::NotEqual.new(column, V::Lucky.to_db!(value)))
  end

  def gt(value) : T
    add_clause(LuckyRecord::Where::GreaterThan.new(column, V::Lucky.to_db!(value)))
  end

  def gte(value) : T
    add_clause(LuckyRecord::Where::GreaterThanOrEqualTo.new(column, V::Lucky.to_db!(value)))
  end

  def lt(value) : T
    add_clause(LuckyRecord::Where::LessThan.new(column, V::Lucky.to_db!(value)))
  end

  def lte(value) : T
    add_clause(LuckyRecord::Where::LessThanOrEqualTo.new(column, V::Lucky.to_db!(value)))
  end

  def select_min : V
    rows.query.select_min(column)
    rows.exec_scalar.as(V)
  end

  def select_max : V
    rows.query.select_max(column)
    rows.exec_scalar.as(V)
  end

  def select_average : Float
    rows.query.select_average(column)
    rows.exec_scalar.as(PG::Numeric).to_f
  end

  def select_sum : Int64
    rows.query.select_sum(column)
    rows.exec_scalar.as(Int64)
  end

  def in(values)
    values = values.map { |value| V::Lucky.to_db!(value) }
    add_clause(LuckyRecord::Where::In.new(column, values))
  end

  def distinct_on
    rows.query.distinct_on(column)
    rows
  end

  private def add_clause(sql_clause)
    sql_clause = build_sql_clause(sql_clause)
    rows.query.where(sql_clause)
    rows
  end

  private def build_sql_clause(sql_clause : LuckyRecord::Where::SqlClause) : LuckyRecord::Where::SqlClause
    if @negate_next_criteria
      sql_clause.negated
    else
      sql_clause
    end
  end
end
