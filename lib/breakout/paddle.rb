require 'java'
require 'lwjgl.jar'
require 'slick.jar'

java_import org.newdawn.slick.Image

require 'breakout/image_context'
require 'breakout/collision'

class Breakout 
  class Paddle
    include Breakout::ImageContext
    include Breakout::Collision
    attr_accessor :x, :y, :velocity

    def initialize
      @image = Image.new('media/paddle.png')
      @y = 400
      reset
    end

    def reset
      @x = 200
      @velocity = 0.3
    end

    def move(delta)
      @x += velocity * delta
    end
  end
end
