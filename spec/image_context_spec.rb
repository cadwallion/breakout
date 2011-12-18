require 'spec_helper'

class TestObject
  include Breakout::ImageContext
  attr_accessor :x, :y
end

shared_examples 'a delegate to the image context' do |attr|
  it 'delegates to the image context' do
    subject.image = double()
    subject.image.stub(attr.to_sym)

    subject.image.should_receive(attr.to_sym)
    subject.send(attr)
  end
end

describe Breakout::ImageContext do
  subject { TestObject.new }
  
  describe '#width' do
    it_behaves_like 'a delegate to the image context', 'width'
  end

  describe '#height' do
    it_behaves_like 'a delegate to the image context', 'height'
  end

  describe '#draw' do
    it_behaves_like 'a delegate to the image context', 'draw'
  end
end
