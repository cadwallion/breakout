require 'spec_helper'

describe Breakout::Ball do
  before do
    Image.stub(:new) { double }
  end
  describe '#initialize' do
    it 'creates an Image context' do
      Image.should_receive(:new).with('media/ball.png')
      Breakout::Ball.new
    end

    it 'calls #reset' do
      Breakout::Ball.any_instance.should_receive(:reset)  
      Breakout::Ball.new
    end
  end

  describe '#reset' do
    it 'resets the velocity' do
      subject.velocity = 5
      subject.reset
      subject.velocity.should == 0.3
    end

    it 'resets the x' do
      subject.x = 500
      subject.reset
      subject.x.should == 200
    end
     
    it 'resets the y' do
      subject.y = 500
      subject.reset
      subject.y.should == 200
    end

    it 'resets the angle' do
      subject.angle = 75
      subject.reset
      subject.angle.should == 45
    end
  end

  describe '#move' do
    it 'adjusts the x by the delta parameter in basic trig alg' do
      orig_x = subject.x
      subject.move(5)
      distance = subject.velocity * 5 * Math.cos(subject.angle * Math::PI / 180)
      subject.x.should == orig_x + distance
    end

    it 'adjusts the y by the delta parameter in basic trig alg' do
      orig_y = subject.y
      subject.move(5)
      distance = subject.velocity * 5 * Math.sin(subject.angle * Math::PI / 180)
      subject.y.should == orig_y - distance
    end
  end

  describe '#bounce' do
    it 'should adjust the angle of the ball by the nearest ninety' do
      orig_angle = subject.angle
      subject.bounce
      subject.angle.should == (orig_angle + 90) % 360
    end
  end
end
