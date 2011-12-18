require 'spec_helper'

describe Breakout::Paddle do
  before do
    Image.stub(:new) { double }
  end

  describe '#initialize' do
    it 'creates an image context' do
      Image.should_receive(:new).with('media/paddle.png')
      Breakout::Paddle.new
    end

    it 'sets the y-axis to a fixed 400' do
      paddle = Breakout::Paddle.new
      paddle.y == 400
    end

    it 'calls #reset' do
      Breakout::Paddle.any_instance.should_receive(:reset)
      Breakout::Paddle.new
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
  end

  describe '#move' do
    it 'shifts the x by the delta parameter' do
      orig_x = subject.x
      subject.move(5)
      subject.x.should == orig_x + subject.velocity * 5
    end
  end
end
