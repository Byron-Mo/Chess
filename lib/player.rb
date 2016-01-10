class Player
  attr_reader :color, :display

  def initialize(display, color)
    @display = display
    @color = color
  end

  def move
    from_pos, to_pos = nil, nil
    until from_pos && to_pos
      @display.display_grid

      if from_pos
        puts "#{color}'s turn. Move to where?"
        to_pos = display.get_input
        display.reset! if to_pos
      else
        puts "#{color}'s turn. Move from where?"
        from_pos = display.get_input
        display.reset! if from_pos
      end
    end
    [from_pos, to_pos]
  end
end
