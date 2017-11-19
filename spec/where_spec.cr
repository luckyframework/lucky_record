require "./spec_helper"

describe LuckyRecord::Where do
  describe "Equal" do
    describe "#negated" do
      it "returns a NotEqual" do
        LuckyRecord::Where::Equal.new("column", "value").negated
          .should be_a LuckyRecord::Where::NotEqual
      end
    end
  end

  describe "NotEqual" do
    describe "#negated" do
      it "returns an Equal" do
        LuckyRecord::Where::NotEqual.new("column", "value").negated
          .should be_a LuckyRecord::Where::Equal
      end
    end
  end

  describe "GreaterThan" do
    describe "#negated" do
      it "returns a LessThanOrEqual" do
        LuckyRecord::Where::GreaterThan.new("column", "value").negated
          .should be_a LuckyRecord::Where::LessThanOrEqualTo
      end
    end
  end

  describe "GreaterThanOrEqualTo" do
    describe "#negated" do
      it "returns a LessThan" do
        LuckyRecord::Where::GreaterThanOrEqualTo.new("column", "value").negated
          .should be_a LuckyRecord::Where::LessThan
      end
    end
  end

  describe "LessThan" do
    describe "#negated" do
      it "returns a GreaterThanOrEqualTo" do
        LuckyRecord::Where::LessThan.new("column", "value").negated
          .should be_a LuckyRecord::Where::GreaterThanOrEqualTo
      end
    end
  end

  describe "LessThanOrEqualTo" do
    describe "#negated" do
      it "returns a GreaterThan" do
        LuckyRecord::Where::LessThanOrEqualTo.new("column", "value").negated
          .should be_a LuckyRecord::Where::GreaterThan
      end
    end
  end

  describe "Like" do
    describe "#negated" do
      it "returns a NotLike" do
        LuckyRecord::Where::Like.new("column", "value").negated
          .should be_a LuckyRecord::Where::NotLike
      end
    end
  end

  describe "NotLike" do
    describe "#negated" do
      it "returns a Like" do
        LuckyRecord::Where::NotLike.new("column", "value").negated
          .should be_a LuckyRecord::Where::Like
      end
    end
  end

  describe "Ilike" do
    describe "#negated" do
      it "returns a Like" do
        LuckyRecord::Where::Ilike.new("column", "value").negated
          .should be_a LuckyRecord::Where::NotIlike
      end
    end
  end

  describe "NotIlike" do
    describe "#negated" do
      it "returns a Ilike" do
        LuckyRecord::Where::NotIlike.new("column", "value").negated
          .should be_a LuckyRecord::Where::Ilike
      end
    end
  end
end
