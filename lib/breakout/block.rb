require 'java'
require 'lwjgl.jar'
require 'slick.jar'

java_import org.newdawn.slick.Image

require 'breakout/image_context'
require 'breakout/collision'

class Breakout
  class Block
    include Breakout::ImageContext
    include Breakout::Collision
    attr_accessor :x, :y
    def initialize(x,y)
      @x = x
      @y = y
      @image = Image.new('media/block.png')
    end
  end
end
