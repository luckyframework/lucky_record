require "./spec_helper"

macro should_negate(original_where, expected_negated_where)
  {% if original_where.resolve < LuckyRecord::Where::NullSqlClause %}
    clause = {{original_where}}.new("column").negated
  {% else %}
    clause = {{original_where}}.new("column", "value").negated
  {% end %}
  clause.column.should eq "column"
  {% unless original_where.resolve < LuckyRecord::Where::NullSqlClause %}
    clause.value.should eq "value"
  {% end %}
  clause.should be_a({{expected_negated_where}})
end

describe LuckyRecord::Where do
  it "can be negated" do
    should_negate(LuckyRecord::Where::Equal, LuckyRecord::Where::NotEqual)
    should_negate(LuckyRecord::Where::NotEqual, LuckyRecord::Where::Equal)
    should_negate(LuckyRecord::Where::GreaterThan, LuckyRecord::Where::LessThanOrEqualTo)
    should_negate(LuckyRecord::Where::GreaterThanOrEqualTo, LuckyRecord::Where::LessThan)
    should_negate(LuckyRecord::Where::LessThan, LuckyRecord::Where::GreaterThanOrEqualTo)
    should_negate(LuckyRecord::Where::LessThanOrEqualTo, LuckyRecord::Where::GreaterThan)
    should_negate(LuckyRecord::Where::Like, LuckyRecord::Where::NotLike)
    should_negate(LuckyRecord::Where::NotLike, LuckyRecord::Where::Like)
    should_negate(LuckyRecord::Where::Ilike, LuckyRecord::Where::NotIlike)
    should_negate(LuckyRecord::Where::NotIlike, LuckyRecord::Where::Ilike)
    should_negate(LuckyRecord::Where::In, LuckyRecord::Where::NotIn)
    should_negate(LuckyRecord::Where::NotIn, LuckyRecord::Where::In)
    should_negate(LuckyRecord::Where::Null, LuckyRecord::Where::NotNull)
  end
end
