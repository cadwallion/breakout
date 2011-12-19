require 'csv'

class Breakout
  class Level
    attr_accessor :blocks

    class << self
      # Takes a level file and converts it into a Level object
      #
      # Format of Level files:
      #   color,number_of_hits,x,y
      #
      # @param [File, #read] File or anything that responds to #read
      # @return [Breakout::Level] The parsed level object
      def load_from_file(f)
        blocks = []
        CSV.parse(f.read) do |row|
          blocks << Block.new(row[0], row[1].to_i, row[2].to_i, row[3].to_i) 
        end
        return self.new(blocks)
      end
    end

    def initialize(blocks)
      @blocks = []
      @blocks.concat(blocks)
    end
    
    # Draws all level information to the screen
    def draw
      @blocks.each do |block|
        block.draw
      end
    end
  end
end
