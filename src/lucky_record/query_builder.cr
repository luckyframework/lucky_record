class LuckyRecord::QueryBuilder
  getter :table
  @limit : Int32?
  @offset : Int32?
  @wheres = [] of LuckyRecord::Where::SqlClause
  @joins = [] of LuckyRecord::Join::SqlClause
  @orders = {
    asc:  [] of Symbol | String,
    desc: [] of Symbol | String,
  }
  @selections : String = "*"
  @prepared_statement_placeholder = 0

  VALID_DIRECTIONS = [:asc, :desc]

  def initialize(@table : Symbol)
  end

  def to_sql
    [statement] + args
  end

  def statement
    join_sql [select_sql] + sql_condition_clauses
  end

  def statement_for_update(params)
    join_sql ["UPDATE #{table}", set_sql_clause(params)] + sql_condition_clauses + ["RETURNING *"]
  end

  def args_for_update(params)
    params.values.map(&.to_s) + prepared_statement_values
  end

  private def set_sql_clause(params)
    "SET " + params.map do |key, value|
      "#{key} = #{next_prepared_statement_placeholder}"
    end.join(", ")
  end

  private def join_sql(clauses)
    clauses.reject do |clause|
      clause.nil? || clause.blank?
    end.join(" ")
  end

  def args
    prepared_statement_values
  end

  private def sql_condition_clauses
    [joins_sql, wheres_sql, order_sql, limit_sql, offset_sql]
  end

  def limit(amount)
    @limit = amount
    self
  end

  def offset(@offset)
    self
  end

  def order_by(column, direction : Symbol)
    raise "Direction must be :asc or :desc, got #{direction}" unless VALID_DIRECTIONS.includes?(direction)
    @orders[direction] << column
    self
  end

  def reverse_order
    @orders = {
      asc: @orders[:desc],
      desc: @orders[:asc],
    }
    self
  end

  def order_sql
    if ordered?
      "ORDER BY " + @orders.map do |direction, columns|
        next if columns.empty?
        columns = columns.map { |column| "#{table}.#{column}" }
        "#{columns.join(", ")} #{direction.to_s.upcase}"
      end.reject(&.nil?).join(", ")
    end
  end

  def count
    if @limit || @offset
      raise LuckyRecord::UnsupportedSQLError.new
    end
    @selections = "COUNT(*)"
    reset_order
    self
  end

  private def reset_order
    @orders.values.each(&.clear)
  end

  def select(selection : Array(Symbol))
    @selections = selection
      .map { |column| "#{@table}.#{column}" }
      .join(", ")
    self
  end

  def ordered?
    @orders.values.any? do |columns|
      columns.any?
    end
  end

  private def select_sql
    "SELECT #{@selections} FROM #{table}"
  end

  private def limit_sql
    if @limit
      "LIMIT #{@limit}"
    end
  end

  private def offset_sql
    if @offset
      "OFFSET #{@offset}"
    end
  end

  def join(join_clause : LuckyRecord::Join::SqlClause)
    @joins << join_clause
    self
  end

  private def joins_sql
    @joins.map(&.to_sql).join(" ")
  end

  def where(where_clause : LuckyRecord::Where::SqlClause)
    @wheres << where_clause
    self
  end

  private def wheres_sql
    if @wheres.any?
      "WHERE " + @wheres.map(&.prepare(next_prepared_statement_placeholder)).join(" AND ")
    end
  end

  private def prepared_statement_values
    @wheres.map(&.value)
  end

  private def next_prepared_statement_placeholder
    @prepared_statement_placeholder += 1
    "$#{@prepared_statement_placeholder}"
  end
end
