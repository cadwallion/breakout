require 'core_ext'

class Breakout
  # Used for collision detection of the ball to the container and the ball to the paddle.
  # This module assumes the existence of dimension attributes (x, y, width, height)
  module Collision
    # Detect block-style object collision
    #
    # @param [Object] Entity to detect collision with
    # @return [Boolean] Collision state
    def is_colliding_with? entity
      entity_x = (entity.x)..(entity.x + entity.width)
      entity_y = (entity.y)..(entity.y + entity.height)
      x_range = (x)..(x + width)
      y_range = (y)..(y + height)

      !(entity_x & x_range).nil? && !(entity_y & y_range).nil?
    end

    # Detect if the object is leaving the containment of `entity`
    #
    # @param [Object] The container entity
    # @param [String] The edge to detect containment on. Defaults to 'all'
    # @return [Boolean] Containment state
    def leaving_the entity, edge = 'all'
      case edge
      when 'all'
        %w{left right top bottom}.each do |direction|
          return true if leaving_the(entity, direction)
        end
      when 'left'
        return x < 0
      when 'right'
        return x > entity.width - width
      when 'top'
        return y < 0
      when 'bottom'
        return y > entity.height
      end
      return false
    end
  end
end
