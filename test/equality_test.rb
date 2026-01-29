# frozen_string_literal: true

require "test_helper"

class EqualityTest < EquitableTestCase
  def test_equality
    assert_equal Point.new(1, 2), Point.new(1, 2)
    assert_equal Point.new(1, 2, "a"), Point.new(1, 2, "b")
    refute_equal Point.new(1, 2), Point.new(9, 2)
    refute_equal Point.new(1, 2), Point.new(1, 9)
  end

  def test_equality_with_subclasses
    refute_equal Point.new(1, 2), ColoredPoint.new(1, 2, "red")
    refute_equal ColoredPoint.new(1, 2, "red"), Point.new(1, 2)
    refute_equal Point.new(1, 2), "string"
    refute_equal Point.new(1, 2), nil
  end

  def test_comparison_delegates_to_attributes
    tracker = Class.new do
      attr_reader :compared_with
      def ==(_other) = (@compared_with = :==) || true
      def eql?(_other) = (@compared_with = :eql?) || true
    end

    wrapper = Class.new do
      include Equitable.new(:value)

      attr_reader :value
      def initialize(value) = @value = value
    end

    t1, t2 = tracker.new, tracker.new

    assert_equal wrapper.new(t1), wrapper.new(tracker.new)
    assert_equal :==, t1.compared_with

    assert wrapper.new(t2).eql?(wrapper.new(tracker.new))
    assert_equal :eql?, t2.compared_with
  end

  def test_equality_requires_type_check
    klass = Class.new do
      include Equitable.new(:x, :y)

      attr_reader :x, :y
      def initialize(x, y) = (@x, @y = x, y)
    end

    duck = Class.new do
      attr_reader :x, :y
      def initialize(x, y) = (@x, @y = x, y)
    end

    refute_equal klass.new(1, 2), duck.new(1, 2)
  end

  def test_equality_checks_all_attributes
    klass = Class.new do
      include Equitable.new(:a, :b)

      attr_reader :a, :b
      def initialize(a, b) = (@a, @b = a, b)
    end

    refute_equal klass.new(1, 2), klass.new(1, 99)
    refute_equal klass.new(1, 2), klass.new(99, 2)
  end

  def test_equality_requires_exact_class
    parent = Class.new do
      include Equitable.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end
    child = Class.new(parent)

    refute_equal parent.new(1), child.new(1)
    refute_equal child.new(1), parent.new(1)
  end
end
