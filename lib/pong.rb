require 'java'
require 'lwjgl.jar'
require 'slick.jar'
require 'pong/ball'
require 'pong/paddle'

java_import org.newdawn.slick.BasicGame
java_import org.newdawn.slick.GameContainer
java_import org.newdawn.slick.Graphics
java_import org.newdawn.slick.Image
java_import org.newdawn.slick.Input
java_import org.newdawn.slick.SlickException

module Pong
  # We subclass BasicGame so we can let Slick2D handle the rendering and main game loop
  # This means we need to define `render`, `init`, and `update`.
  class Game < BasicGame
    def initialize
      super('RubyPong') 
    end

    # This method is called continuously.  Rule of thumb: Always redraw the screen from blank.  You do not 
    # because you do not know if `update` will have been called.
    def render(container, graphics)
      @bg.draw(0, 0)
      @ball.draw
      @paddle.draw
      graphics.draw_string('RubyPong (ESC to exit)', 8, container.height - 30)
    end

    # Establishes the connection between container and game state. Creates our game objects. We have `init`
    # AND `initialize` because Java sucks at naming...
    # 
    # @param [AppContainer] - The AppContainer state
    def init(container)
      @bg = Image.new('bg.png')
      @ball = Pong::Ball.new
      @paddle = Pong::Paddle.new
    end

    # This is your game logic method.  This will be called continuously in the main game loop and should be
    # the entry point for input handling and game state change.  Do NOT put rendering logic in the update method
    # due to the nature of update vs render running potentially simultaneously
    # 
    # @param [AppContainer] - The AppContainer game state
    # @param [Float] - The time since last update call
    def update(container, delta)
      handle_input(container, delta)
      @ball.move(delta)
      collision_detection(container)
    end

    # Handles input to move the paddle left/right and game exit. 
    # Controls: [LEFT/A] for left, [RIGHT/D] for right, [ESC] to exit
    # 
    # Input handler.  Every key is mapped to a constant in the Input class.  This method is not an override, but
    # it's a good idea to isolate your input handler from your game logic as it will be the second most bloated
    # point for game logic
    # 
    # @param [AppContainer] - The AppContainer game state
    # @param [Float] - Time since last update call
    def handle_input(container, delta)
      input = container.get_input
      container.exit if input.is_key_down(Input::KEY_ESCAPE)

      @paddle.move(-delta) if (input.is_key_down(Input::KEY_LEFT) || input.is_key_down(Input::KEY_A)) && !@paddle.container_collision(container, 'left')
      @paddle.move(delta) if (input.is_key_down(Input::KEY_RIGHT) || input.is_key_down(Input::KEY_D)) && !@paddle.container_collision(container, 'right')
    end

    # Collision detection for the ball staying within the window container
    #
    # @param [container] - the AppContainer object state
    def collision_detection(container)
      if @ball.colliding_with_container? container
        @ball.angle = (@ball.angle + 90) % 360
      end

      if @ball.container_collision(container, 'bottom')
        @paddle.reset
        @ball.reset
      end

      if @ball.is_colliding_with? @paddle
        @ball.angle = (@ball.angle + 90) % 360
      end  
    end
  end
end
