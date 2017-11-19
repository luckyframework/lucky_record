class LuckyRecord::Criteria(T, V)
  property :rows, :column
  @negate_next_criteria : Bool

  def initialize(@rows : T, @column : Symbol)
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
    sql_clause = build_sql_clause(LuckyRecord::Where::Equal.new(column, V::Lucky.to_db!(value)))
    rows.query.where(sql_clause)
    rows
  end

  def not(value) : T
    is_not(value)
  end

  def not : LuckyRecord::Criteria
    @negate_next_criteria = true
    # LuckyRecord::NegatedCriteria.new(@rows, @column)
    self
  end

  def is_not(value)
    rows.query.where(LuckyRecord::Where::NotEqual.new(column, V::Lucky.to_db!(value)))
    rows
  end

  def gt(value)
    rows.query.where(LuckyRecord::Where::GreaterThan.new(column, V::Lucky.to_db!(value)))
    rows
  end

  def gte(value)
    rows.query.where(LuckyRecord::Where::GreaterThanOrEqualTo.new(column, V::Lucky.to_db!(value)))
    rows
  end

  def lt(value)
    rows.query.where(LuckyRecord::Where::LessThan.new(column, V::Lucky.to_db!(value)))
    rows
  end

  def lte(value)
    rows.query.where(LuckyRecord::Where::LessThanOrEqualTo.new(column, V::Lucky.to_db!(value)))
    rows
  end

  def like(value)
    sql_clause = build_sql_clause(LuckyRecord::Where::Like.new(column, V::Lucky.to_db!(value)))
    rows.query.where(sql_clause)
    rows
  end

  def ilike(value)
    sql_clause = build_sql_clause(LuckyRecord::Where::Ilike.new(column, V::Lucky.to_db!(value)))
    rows.query.where(sql_clause)
    rows
  end

  def build_sql_clause(sql_clause : LuckyRecord::Where::SqlClause) : LuckyRecord::Where::SqlClause
    if @negate_next_criteria
      sql_clause.negated
    else
      sql_clause
    end
  end
end
