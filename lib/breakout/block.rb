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
    attr_accessor :max_hits, :current_hits, :x, :y
    def initialize(color, hits, x, y)
      @x = x
      @y = y
      @max_hits = hits
      @current_hits = 0
      @image = Image.new("media/#{color}-block.png")
    end
      
    # Increases the hits taken, adjusts which image should be loaded
    def hit!
      @current_hits += 1 
      # @TODO: Change sprite index to next element        
    end

    def destroyed?
      (@current_hits >= @max_hits) 
    end
  end
end
