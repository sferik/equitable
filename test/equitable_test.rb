# frozen_string_literal: true

require "test_helper"

class EquitableTest < EquitableTestCase
  def test_creates_module_with_descriptive_name
    mod = Equitable.new(:foo, :bar)

    assert_kind_of Module, mod
    assert_equal "Equitable(foo, bar)", mod.name
  end

  def test_equitable_keys_is_private
    klass = Class.new do
      include Equitable.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    obj = klass.new(1)

    assert_includes klass.private_instance_methods, :equitable_keys
    assert_raises(NoMethodError) { obj.equitable_keys }
  end

  def test_keys_are_frozen
    klass = Class.new do
      include Equitable.new(:x)

      attr_reader :x
      def initialize(x) = @x = x
    end

    obj = klass.new(1)
    keys = obj.send(:equitable_keys)

    assert_predicate keys, :frozen?
    assert_raises(FrozenError) { keys << :y }
  end

  def test_raises_on_invalid_keys
    error = assert_raises(ArgumentError) { Equitable.new }
    assert_equal "at least one attribute is required", error.message

    error = assert_raises(ArgumentError) { Equitable.new("foo") }
    assert_equal "attribute must be a Symbol, got String", error.message
  end

  def test_uses_case_equality_for_symbol_validation
    error = assert_raises(ArgumentError) { Equitable.new(Object.new) }

    assert_match(/attribute must be a Symbol, got Object/, error.message)
  end

  def test_reports_all_unique_invalid_types
    error = assert_raises(ArgumentError) { Equitable.new("foo", 123, "bar", 4.5) }

    assert_equal "attribute must be a Symbol, got String, Integer, Float", error.message
  end

  def test_each_call_creates_independent_module
    mod1 = Equitable.new(:foo)
    mod2 = Equitable.new(:bar)

    refute_same mod1, mod2
  end
end
