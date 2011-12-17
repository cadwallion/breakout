class Breakout
  # Images in Slick2D work differently than...well, any other game library I've worked with. Instead of
  # explicitly binding images to the window context, it implicitly binds them by only allowing a single
  # container to be instantiated.
  #
  # ImageContext handles delegation of coordinates and sizing of an object to the image context.  In Pong,
  # we use this for the Pong and Paddle
  module ImageContext
    attr_accessor :image

    def width
      @image.width 
    end

    def height
      @image.height
    end

    def draw
      @image.draw(@x, @y)
    end
  end
end
