class Company < LuckyRecord::Model
  table companies do
    column sales : Int64
  end
end