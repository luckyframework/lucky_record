class LineItem < LuckyRecord::Model
  table :line_items, primary_key_type: :uuid do
    column name : String
    has_one price : Price?
  end
end

class LineItemQuery < LineItem::BaseQuery
end
