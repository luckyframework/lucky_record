require "uuid"

class LineItemBox < BaseBox
  def initialize
    id  UUID.random.to_s
    name "A pair of shoes"
  end
end
