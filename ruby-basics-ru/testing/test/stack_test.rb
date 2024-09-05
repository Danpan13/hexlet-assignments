# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/stack'


class StackTest < Minitest::Test
  def setup
    @stack = Stack.new
  end

  def test_push_element
    @stack.push(1)
    assert_includes @stack.to_a, 1
  end

  def test_pop_element
    @stack.push(2)
    popped = @stack.pop
    assert_equal 2, popped
    assert_empty @stack.to_a
  end

  def test_clear_stack
    @stack.push(3)
    @stack.push(4)
    @stack.clear
    assert_empty @stack.to_a
  end

  def test_empty_stack
    assert @stack.empty?
    @stack.push(5)
    refute @stack.empty?
    @stack.pop
    assert @stack.empty?
  end
end

test_methods = StackTest.new({}).methods.select { |method| method.start_with? 'test_' }
raise 'StackTest has not tests!' if test_methods.empty?
