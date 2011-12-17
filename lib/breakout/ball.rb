require 'java'
require 'lwjgl.jar'
require 'slick.jar'

java_import org.newdawn.slick.Image

require 'breakout/image_context'
require 'breakout/collision'

class Breakout
  class Ball
    include Breakout::ImageContext
    include Breakout::Collision
    attr_accessor :x, :y, :velocity, :angle

    def initialize
      @image = Image.new('media/ball.png')
      reset
    end

    def reset
      @x = 200
      @y = 200
      @angle = 45     
      @velocity = 0.3
    end

    def move(delta)
      @x += @velocity * delta * Math.cos(@angle * Math::PI / 180)
      @y -= @velocity * delta * Math.sin(@angle * Math::PI / 180)
    end

    def bounce
      @angle = (@angle + 90) % 360 
    end
  end
end
