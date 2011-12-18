require 'spec_helper'

describe Breakout::Block do
  subject { Breakout::Block.new('orange', 1, 5,5) }
  before do
    Image.stub(:new) { double }

    describe '#initialize' do
      it 'sets the x and y to the passed parameters' do
        subject.x.should == 5
        subject.y.should == 5
      end

      it 'creates an image context' do
        Image.should_receive(:new).with('media/block.png')
        Breakout::Block.new('orange', 1, 5, 5)
      end
    end

    describe '#hit!' do
      it 'increments the current_hits counter' do
        orig_hits = subject.current_hits
        subject.hit!
        subject.hits.should == orig_hits  + 1
      end
    end

    describe '#destroyed?' do
      it 'returns true if current_hits is equal or greater than max_hits' do
        subject.hit!
        subject.destroyed?.should be_true
      end
    end
  end
end
