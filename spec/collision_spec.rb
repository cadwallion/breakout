require 'spec_helper'

class TestCollisionObject
  include Breakout::Collision
  attr_accessor :x, :y, :width, :height

  def initialize(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
  end
end

describe Breakout::Collision do
  describe '#is_colliding_with?' do
    it 'returns true if objects intersect on the x- and y-axis' do
      objA = TestCollisionObject.new(10, 10, 25, 25)
      objB = TestCollisionObject.new(15, 15, 10, 10)
      objA.is_colliding_with?(objB).should be_true
    end

    it 'returns false if objects intersect on the x-axis but not the y-axis' do
      objA = TestCollisionObject.new(10, 10, 25, 25)
      objB = TestCollisionObject.new(15, 40, 10, 10)
      objA.is_colliding_with?(objB).should be_false
    end

    it 'returns false if objects intersect on the y-axis but not the x-axis' do
      objA = TestCollisionObject.new(10, 10, 25, 25)
      objB = TestCollisionObject.new(40, 20, 10, 10)
      objA.is_colliding_with?(objB).should be_false
    end
  end

  describe '#leaving_the' do
    context 'default context or passing "all" as edge parameter' do
      it 'returns false if objects intersect on the x- and y-axis' do
        objA = TestCollisionObject.new(15, 15, 25, 25)
        containerObj = TestCollisionObject.new(0, 0, 100, 100)
        objA.leaving_the(containerObj).should be_false
      end

      it 'returns true if objects intersect on the x-axis but not the y-axis' do
        objA = TestCollisionObject.new(60, 15, 25, 25)
        containerObj = TestCollisionObject.new(0, 0, 50, 50)
        objA.leaving_the(containerObj).should be_true
      end

      it 'returns true if objects intersect on the y-axis but not the x-axis' do
        objA = TestCollisionObject.new(15, 60, 25, 25)
        containerObj = TestCollisionObject.new(0, 0, 50, 50)
        objA.leaving_the(containerObj).should be_true
      end
    end

    context 'passing "left" as edge parameter' do
      it 'returns false if object is to the right of the container x coordinate' do
        objA = TestCollisionObject.new(15, -15, 25, 25)
        containerObj = TestCollisionObject.new(0, 0, 50, 50)
        objA.leaving_the(containerObj, 'left').should be_false
      end

      it 'returns true if object is to the left of the container x coordinate' do
        objA = TestCollisionObject.new(-15, 5, 25, 25)
        containerObj = TestCollisionObject.new(0, 0, 50, 50)
        objA.leaving_the(containerObj, 'left').should be_true
      end
    end

    context 'passing "right" as the edge parameter' do
      it 'returns false if object is to the left of the container x object space' do
        objA = TestCollisionObject.new(10, 5, 25, 25)
        containerObj = TestCollisionObject.new(0, 0, 50, 50)
        objA.leaving_the(containerObj, 'right').should be_false
      end

      it 'returns true if object is to the right of the container x object space' do
        objA = TestCollisionObject.new(60, 5, 25, 25)
        containerObj = TestCollisionObject.new(0, 0, 50, 50)
        objA.leaving_the(containerObj, 'right').should be_true
      end
    end

    context 'passing "bottom" as the edge parameter' do
      it 'returns false if object is above the container y object space' do
        objA = TestCollisionObject.new(60, 5, 25, 25)
        containerObj = TestCollisionObject.new(0, 0, 50, 50)
        objA.leaving_the(containerObj, 'bottom').should be_false
      end

      it 'returns true if object is below the container y object space' do
        objA = TestCollisionObject.new(0, 60, 25, 25)
        containerObj = TestCollisionObject.new(0, 0, 50, 50)
        objA.leaving_the(containerObj, 'bottom').should be_true
      end
    end

    context 'passing "top" as the edge parameter' do
      it 'returns false if object is below the container y coordinate' do
        objA = TestCollisionObject.new(0, 60, 25, 25)
        containerObj = TestCollisionObject.new(0, 0, 50, 50)
        objA.leaving_the(containerObj, 'top').should be_false
      end

      it 'returns true if object is above the container y coordinate' do
        objA = TestCollisionObject.new(0, -5, 25, 25)
        containerObj = TestCollisionObject.new(0, 0, 50, 50)
        objA.leaving_the(containerObj, 'top').should be_true
      end
    end
  end
end
