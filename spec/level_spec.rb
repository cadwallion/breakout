require 'spec_helper'

class TestLevelFile
  def read
    "orange,1,25,25\n" 
  end
end

describe Breakout::Level do
  before do
    Image.stub(:new) { double }
  end

  describe '#load_from_file' do
    it 'calls CSV.read on the passed parameter' do
      CSV.should_receive(:parse) 
      Breakout::Level.load_from_file(TestLevelFile.new)
    end

    it 'generates block objects for each record in the file' do
      level = Breakout::Level.load_from_file(TestLevelFile.new)
      level.blocks.size.should == 1
      level.blocks.first.class.name.should == 'Breakout::Block'
    end

    it 'returns a new Level object' do
      level = Breakout::Level.load_from_file(TestLevelFile.new)
      level.class.name.should == 'Breakout::Level'
    end
  end

  describe '#initialize' do
    it 'sets the blocks to the passed parameter' do
      blocks = [Breakout::Block.new('orange', 1, 25, 25)]
      level = Breakout::Level.new(blocks)
      level.blocks.should == blocks
    end
  end

  describe '#draw' do
    it 'calls #draw to each block in the blocks property' do
      blocks = [Breakout::Block.new('orange', 1, 25, 25)]
      level = Breakout::Level.new(blocks)
      Breakout::Block.any_instance.should_receive(:draw).exactly(blocks.size).times
      level.draw
    end
  end
end
