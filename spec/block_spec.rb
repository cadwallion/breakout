require 'spec_helper'

describe Breakout::Block do
  subject { Breakout::Block.new(5,5) }
  before do
    Image.stub(:new) { double }

    describe '#initialize' do
      it 'sets the x and y to the passed parameters' do
        subject.x.should == 5
        subject.y.should == 5
      end

      it 'creates an image context' do
        Image.should_receive(:new).with('media/block.png')
        Breakout::Block.new
      end
    end
  end
end
