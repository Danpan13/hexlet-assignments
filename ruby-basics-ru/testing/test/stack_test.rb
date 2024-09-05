# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/stack'


class StackTest < Minitest::Test
  def setup
    @stack = Stack.new
  end

  def test_push_element
    @stack.push! "php"
    assert { @stack.instance_variable_get(:@elements).include?("php") }
  end
  def test_pop_element
    @stack.push! "java"
    element = @stack.pop!
    assert { element == "java" }
    assert { @stack.empty? }
  end

  def test_clear_stack
    @stack.push! 1
    @stack.push! 2
    @stack.clear!
    assert { @stack.empty? }
  end

  def test_empty_stack
    assert { @stack.empty? }
    @stack.push! 1
    assert { !@stack.empty? }
  end
end

test_methods = StackTest.new({}).methods.select { |method| method.start_with? 'test_' }
raise 'StackTest has not tests!' if test_methods.empty?
