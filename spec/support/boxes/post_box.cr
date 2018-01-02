class PostBox < BaseBox
  def initialize
    title "My Cool Title"
  end

  def build_model
    Post.new(1, Time.now, Time.now, "title", Time.now)
  end
end
