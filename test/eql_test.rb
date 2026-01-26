# frozen_string_literal: true

require "test_helper"

class EqlTest < EquitableTestCase
  def test_eql
    assert Point.new(1, 2).eql?(Point.new(1, 2))
    refute Point.new(1, 2).eql?(Point.new(9, 9))
    refute Point.new(1, 2).eql?(nil)
    refute Point.new(1, 2).eql?("string")
  end

  def test_eql_requires_exact_class
    refute Point.new(1, 2).eql?(ColoredPoint.new(1, 2, "red"))
    refute ColoredPoint.new(1, 2, "red").eql?(Point.new(1, 2))
  end

  def test_eql_requires_type_check
    klass = Class.new do
      include Equitable.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    duck = Class.new do
      attr_reader :x
      def initialize(x) = @x = x
    end

    refute klass.new(1).eql?(duck.new(1))
  end

  def test_eql_checks_all_attributes
    klass = Class.new do
      include Equitable.new(:a, :b)

      attr_reader :a, :b
      def initialize(a, b) = (@a, @b = a, b)
    end

    refute klass.new(1, 2).eql?(klass.new(1, 99))
    refute klass.new(1, 2).eql?(klass.new(99, 2))
  end
end
